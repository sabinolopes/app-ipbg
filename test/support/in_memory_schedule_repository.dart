import 'package:app_igreja_guacui/domains/schedule/schedule_repository.dart';
import 'package:app_igreja_guacui/domains/schedule/types.dart';

class InMemoryScheduleRepository implements ScheduleRepository {
  InMemoryScheduleRepository(List<ScheduleSlot> slots)
    : _availableSlots = [...slots];

  final List<ScheduleSlot> _availableSlots;
  final List<AppointmentRequest> appointments = [];
  bool isOffline = false;

  @override
  Future<List<ScheduleSlot>> listAvailableSlots() async {
    if (isOffline) throw Exception('no connection');

    return [..._availableSlots];
  }

  @override
  Future<void> createAppointment(AppointmentRequest request) async {
    if (isOffline) throw Exception('no connection');

    final isAvailable = _availableSlots.any(
      (slot) => slot.id == request.slotId,
    );
    if (!isAvailable) throw const SlotUnavailableException();

    reserve(request.slotId);
    appointments.add(request);
  }

  /// Takes the slot the way another person's request would.
  void reserve(String slotId) {
    _availableSlots.removeWhere((slot) => slot.id == slotId);
  }
}
