-- Position on the board the contact belongs to: the Conselho for the pastor
-- and elders, the Junta Diaconal for deacons.
alter table public.contacts
  add column board_position text
    check (board_position in ('president', 'vice_president', 'first_secretary', 'second_secretary'));
