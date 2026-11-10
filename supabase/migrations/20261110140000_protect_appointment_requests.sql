-- The app is not trusted: the same rules it applies are enforced here.
alter table public.appointments
  add constraint appointments_requester_name_length
    check (char_length(btrim(requester_name)) between 3 and 80),
  add constraint appointments_requester_phone_format
    check (requester_phone ~ '^[0-9]{10,11}$');

-- Defense in depth for the reservation trigger below.
create unique index appointments_one_active_per_slot
  on public.appointments (slot_id)
  where status <> 'cancelled';

-- The public API may only create pending requests.
drop policy appointments_public_insert on public.appointments;
create policy appointments_public_insert on public.appointments
  for insert to anon
  with check (status = 'pending');

-- Reserves the slot in the same transaction as the request. The row lock
-- makes two simultaneous requests for the same slot run one after the other.
create function public.reserve_schedule_slot()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  slot_starts_at timestamp;
  slot_is_available boolean;
begin
  if new.status = 'cancelled' then
    return new;
  end if;

  select s.date + s.start_time, s.is_available
    into slot_starts_at, slot_is_available
    from public.schedule_slots s
   where s.id = new.slot_id
     for update;

  if not found
     or not slot_is_available
     or slot_starts_at <= (now() at time zone 'America/Sao_Paulo') then
    raise exception 'slot_unavailable' using errcode = 'P0001';
  end if;

  update public.schedule_slots set is_available = false where id = new.slot_id;
  return new;
end;
$$;

create trigger appointments_reserve_slot
  before insert on public.appointments
  for each row execute function public.reserve_schedule_slot();

-- Cancelling or deleting a request in the Table Editor frees the slot again.
create function public.sync_schedule_slot_availability()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if tg_op = 'DELETE' then
    if old.status <> 'cancelled' then
      update public.schedule_slots set is_available = true where id = old.slot_id;
    end if;
    return old;
  end if;

  update public.schedule_slots
     set is_available = (new.status = 'cancelled')
   where id = new.slot_id;
  return new;
end;
$$;

create trigger appointments_sync_slot_on_status_change
  after update of status on public.appointments
  for each row
  when (old.status is distinct from new.status)
  execute function public.sync_schedule_slot_availability();

create trigger appointments_sync_slot_on_delete
  after delete on public.appointments
  for each row execute function public.sync_schedule_slot_availability();

revoke execute on function public.reserve_schedule_slot() from public, anon, authenticated;
revoke execute on function public.sync_schedule_slot_availability() from public, anon, authenticated;
