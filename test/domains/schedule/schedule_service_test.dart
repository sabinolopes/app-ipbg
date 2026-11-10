import 'package:app_igreja_guacui/domains/schedule/schedule_service.dart';
import 'package:app_igreja_guacui/domains/schedule/types.dart';
import 'package:app_igreja_guacui/shared/result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_schedule_repository.dart';

final _now = DateTime(2026, 11, 10, 12);

ScheduleSlot _slot(String id, DateTime start) {
  return ScheduleSlot(
    id: id,
    start: start,
    end: start.add(const Duration(hours: 1)),
  );
}

AppointmentForm _form({String slotId = 'slot-1', String name = 'Maria Silva'}) {
  return AppointmentForm(
    slotId: slotId,
    requesterName: name,
    requesterPhone: '(28) 99999-0000',
  );
}

void main() {
  group('listing slots', () {
    test('shows only slots that have not started, earliest first', () async {
      final repository = InMemoryScheduleRepository([
        _slot('later', DateTime(2026, 11, 19, 9)),
        _slot('past', DateTime(2026, 8, 27, 14)),
        _slot('started-now', _now),
        _slot('sooner', DateTime(2026, 11, 10, 15)),
      ]);

      final result = await listAvailableSlots(
        repository: repository,
        now: _now,
      );

      final ids = (result as Success<List<ScheduleSlot>>).data.map(
        (slot) => slot.id,
      );
      expect(ids, ['sooner', 'later']);
    });

    test('returns a failure with a friendly message when it breaks', () async {
      final repository = InMemoryScheduleRepository([])..isOffline = true;

      final result = await listAvailableSlots(
        repository: repository,
        now: _now,
      );

      expect((result as Failure).message, slotsLoadErrorMessage);
    });
  });

  group('requesting an appointment', () {
    test('saves the request with cleaned name and phone', () async {
      final repository = InMemoryScheduleRepository([
        _slot('slot-1', DateTime(2026, 11, 17, 14)),
      ]);

      final result = await requestAppointment(
        repository: repository,
        form: _form(name: '  Maria   Silva '),
      );

      expect(result, isA<Success<AppointmentRequest>>());
      final saved = repository.appointments.single;
      expect(saved.slotId, 'slot-1');
      expect(saved.requesterName, 'Maria Silva');
      expect(saved.requesterPhone, '28999990000');
    });

    test('refuses a second request for the same slot', () async {
      final repository = InMemoryScheduleRepository([
        _slot('slot-1', DateTime(2026, 11, 17, 14)),
      ]);
      await requestAppointment(repository: repository, form: _form());

      final result = await requestAppointment(
        repository: repository,
        form: _form(name: 'João Souza'),
      );

      expect((result as Failure).message, slotUnavailableMessage);
      expect(repository.appointments, hasLength(1));
    });

    test('does not save anything when the form is invalid', () async {
      final repository = InMemoryScheduleRepository([
        _slot('slot-1', DateTime(2026, 11, 17, 14)),
      ]);

      final result = await requestAppointment(
        repository: repository,
        form: _form(name: ''),
      );

      expect((result as Failure).message, 'Informe seu nome.');
      expect(repository.appointments, isEmpty);
    });

    test('tells the user when the request could not be sent', () async {
      final repository = InMemoryScheduleRepository([
        _slot('slot-1', DateTime(2026, 11, 17, 14)),
      ])..isOffline = true;

      final result = await requestAppointment(
        repository: repository,
        form: _form(),
      );

      expect((result as Failure).message, appointmentNotSentMessage);
      expect(repository.appointments, isEmpty);
    });
  });
}
