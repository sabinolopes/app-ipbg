import 'package:app_igreja_guacui/domains/contacts/contacts_service.dart';
import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:app_igreja_guacui/ui/pages/contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_contacts_repository.dart';

const _pastor = Contact(
  id: '1',
  name: 'Rinaldo Berbert',
  role: Role.pastor,
  phone: '+55 27 99994-9911',
);

Future<void> _openPage(
  WidgetTester tester,
  InMemoryContactsRepository repository,
) {
  return tester.pumpWidget(
    MaterialApp(
      home: ContactsPage(
        loadContacts: () => listContacts(repository: repository),
      ),
    ),
  );
}

void main() {
  testWidgets('shows the loading state and then the contacts', (tester) async {
    await _openPage(tester, InMemoryContactsRepository([_pastor]));

    expect(find.bySemanticsLabel('Carregando contatos'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Rinaldo Berbert'), findsOneWidget);
    expect(find.text('Pastor · +55 27 99994-9911'), findsOneWidget);
  });

  testWidgets('tells the user when there are no contacts', (tester) async {
    await _openPage(tester, InMemoryContactsRepository([]));
    await tester.pumpAndSettle();

    expect(find.text('Nenhum contato cadastrado ainda.'), findsOneWidget);
  });

  testWidgets('shows the error and reloads on retry', (tester) async {
    final repository = InMemoryContactsRepository([_pastor])..isOffline = true;
    await _openPage(tester, repository);
    await tester.pumpAndSettle();

    expect(find.text(contactsLoadErrorMessage), findsOneWidget);

    repository.isOffline = false;
    await tester.tap(find.widgetWithText(FilledButton, 'Tentar novamente'));
    await tester.pumpAndSettle();

    expect(find.text(contactsLoadErrorMessage), findsNothing);
    expect(find.text('Rinaldo Berbert'), findsOneWidget);
  });
}
