import 'package:app_igreja_guacui/domains/schedule/types.dart';

abstract interface class ScheduleRepository {
  Future<List<ScheduleSlot>> listAvailableSlots();

  /// Throws [SlotUnavailableException] when the slot was taken or is past.
  Future<void> createAppointment(AppointmentRequest request);
}
