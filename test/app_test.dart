import 'package:app_igreja_guacui/app.dart';
import 'package:app_igreja_guacui/domains/bulletins/bulletins_service.dart';
import 'package:app_igreja_guacui/domains/bulletins/types.dart';
import 'package:app_igreja_guacui/domains/contacts/contacts_service.dart';
import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/in_memory_bulletins_repository.dart';
import 'support/in_memory_contacts_repository.dart';

void main() {
  testWidgets('starts on the bulletins and switches to the contacts', (
    tester,
  ) async {
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

    await tester.pumpWidget(
      App(
        loadBulletins: () => listBulletins(repository: bulletinsRepository),
        loadContacts: () => listContacts(repository: contactsRepository),
        openLink: (link) async => true,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Boletim de agosto'), findsOneWidget);
    expect(find.text('Rinaldo Berbert'), findsNothing);

    await tester.tap(find.text('Contatos'));
    await tester.pumpAndSettle();

    expect(find.text('Rinaldo Berbert'), findsOneWidget);
    expect(find.text('Boletim de agosto'), findsNothing);
  });
}
