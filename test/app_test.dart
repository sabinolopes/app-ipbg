import 'package:app_igreja_guacui/app.dart';
import 'package:app_igreja_guacui/app_dependencies.dart';
import 'package:app_igreja_guacui/domains/bulletins/bulletins_service.dart';
import 'package:app_igreja_guacui/domains/bulletins/types.dart';
import 'package:app_igreja_guacui/domains/contacts/contacts_service.dart';
import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:app_igreja_guacui/domains/schedule/schedule_service.dart';
import 'package:app_igreja_guacui/domains/schedule/types.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/in_memory_bulletins_repository.dart';
import 'support/in_memory_contacts_repository.dart';
import 'support/in_memory_schedule_repository.dart';

AppDependencies _dependencies() {
  final bulletinsRepository = InMemoryBulletinsRepository([
    Bulletin(
      id: '1',
      title: 'Boletim de agosto',
      publicationDate: DateTime(2026, 8, 24),
    ),
  ]);
  final contactsRepository = InMemoryContactsRepository([
    const Contact(id: '1', name: 'Rinaldo Berbert', role: Role.pastor),
  ]);
  final scheduleRepository = InMemoryScheduleRepository([
    ScheduleSlot(
      id: '1',
      start: DateTime(2026, 11, 17, 14),
      end: DateTime(2026, 11, 17, 15),
    ),
  ]);

  return AppDependencies(
    loadBulletins: () => listBulletins(repository: bulletinsRepository),
    loadContacts: () => listContacts(repository: contactsRepository),
    loadAvailableSlots: () => listAvailableSlots(
      repository: scheduleRepository,
      now: DateTime(2026, 11, 10),
    ),
    requestAppointment: (form) =>
        requestAppointment(repository: scheduleRepository, form: form),
    openLink: (link) async => true,
  );
}

void main() {
  testWidgets('starts on the bulletins and switches between sections', (
    tester,
  ) async {
    await tester.pumpWidget(App(dependencies: _dependencies()));
    await tester.pumpAndSettle();

    expect(find.text('Boletim de agosto'), findsOneWidget);

    await tester.tap(find.text('Agenda'));
    await tester.pumpAndSettle();

    expect(find.text('terça-feira, 17 de novembro'), findsOneWidget);
    expect(find.text('Boletim de agosto'), findsNothing);

    await tester.tap(find.text('Contatos'));
    await tester.pumpAndSettle();

    expect(find.text('Rinaldo Berbert'), findsOneWidget);
    expect(find.text('terça-feira, 17 de novembro'), findsNothing);
  });
}
