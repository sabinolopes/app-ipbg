class ScheduleSlot {
  const ScheduleSlot({
    required this.id,
    required this.start,
    required this.end,
  });

  final String id;
  final DateTime start;
  final DateTime end;
}

/// What the user typed, before validation.
class AppointmentForm {
  const AppointmentForm({
    required this.slotId,
    required this.requesterName,
    required this.requesterPhone,
  });

  final String slotId;
  final String requesterName;
  final String requesterPhone;
}

/// A validated request, ready to be saved.
class AppointmentRequest {
  const AppointmentRequest({
    required this.slotId,
    required this.requesterName,
    required this.requesterPhone,
  });

  final String slotId;
  final String requesterName;
  final String requesterPhone;
}

class SlotUnavailableException implements Exception {
  const SlotUnavailableException();
}

class AppointmentNotSavedException implements Exception {
  const AppointmentNotSavedException(this.code);

  final String? code;

  @override
  String toString() => 'AppointmentNotSavedException(code: $code)';
}

List<ScheduleSlot> upcomingSlots(
  List<ScheduleSlot> slots, {
  required DateTime now,
}) {
  final futureSlots = slots.where((slot) => slot.start.isAfter(now)).toList();
  return futureSlots
    ..sort((first, second) => first.start.compareTo(second.start));
}
