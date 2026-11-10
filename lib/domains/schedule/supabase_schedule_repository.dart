import 'package:app_igreja_guacui/domains/schedule/schedule_repository.dart';
import 'package:app_igreja_guacui/domains/schedule/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _slotsTable = 'schedule_slots';
const _slotColumns = 'id, date, start_time, end_time';
const _appointmentsTable = 'appointments';

// Raised by the reserve_schedule_slot trigger.
const _slotUnavailableCode = 'P0001';
// Unique index appointments_one_active_per_slot.
const _uniqueViolationCode = '23505';

class SupabaseScheduleRepository implements ScheduleRepository {
  const SupabaseScheduleRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<ScheduleSlot>> listAvailableSlots() async {
    final rows = await _client
        .from(_slotsTable)
        .select(_slotColumns)
        .eq('is_available', true);
    return rows.map(slotFromRow).toList();
  }

  @override
  Future<void> createAppointment(AppointmentRequest request) async {
    try {
      await _client.from(_appointmentsTable).insert({
        'slot_id': request.slotId,
        'requester_name': request.requesterName,
        'requester_phone': request.requesterPhone,
      });
    } on PostgrestException catch (error) {
      // The database error is not passed on: its details can repeat the
      // requester's name and phone, which must never reach the logs.
      if (isSlotUnavailableError(error.code)) {
        throw const SlotUnavailableException();
      }
      throw AppointmentNotSavedException(error.code);
    }
  }
}

ScheduleSlot slotFromRow(Map<String, dynamic> row) {
  final date = row['date'] as String;

  return ScheduleSlot(
    id: row['id'] as String,
    start: DateTime.parse('${date}T${row['start_time']}'),
    end: DateTime.parse('${date}T${row['end_time']}'),
  );
}

bool isSlotUnavailableError(String? code) {
  return code == _slotUnavailableCode || code == _uniqueViolationCode;
}
