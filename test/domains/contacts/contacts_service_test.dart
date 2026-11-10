import 'package:app_igreja_guacui/domains/contacts/contacts_service.dart';
import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:app_igreja_guacui/shared/result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_contacts_repository.dart';

Contact _contact(String name, Role role, {BoardPosition? boardPosition}) {
  return Contact(
    id: name,
    name: name,
    role: role,
    boardPosition: boardPosition,
  );
}

Iterable<String> _names(Result<List<Contact>> result) {
  return (result as Success<List<Contact>>).data.map((contact) => contact.name);
}

void main() {
  test('lists the pastor first, then elders, then deacons', () async {
    final repository = InMemoryContactsRepository([
      _contact('Davi', Role.deacon),
      _contact('Paulo', Role.elder),
      _contact('Rinaldo', Role.pastor),
    ]);

    final result = await listContacts(repository: repository);

    expect(_names(result), ['Rinaldo', 'Paulo', 'Davi']);
  });

  test('sorts by name within the same role, ignoring letter case', () async {
    final repository = InMemoryContactsRepository([
      _contact('reinaldo', Role.elder),
      _contact('Paulo', Role.elder),
      _contact('Abel', Role.elder),
    ]);

    final result = await listContacts(repository: repository);

    expect(_names(result), ['Abel', 'Paulo', 'reinaldo']);
  });

  test('lists board members by position before the other members', () async {
    final repository = InMemoryContactsRepository([
      _contact('Abel', Role.deacon),
      _contact(
        'Marco',
        Role.deacon,
        boardPosition: BoardPosition.secondSecretary,
      ),
      _contact('Saulo', Role.deacon, boardPosition: BoardPosition.president),
      _contact(
        'Rogerr',
        Role.deacon,
        boardPosition: BoardPosition.vicePresident,
      ),
    ]);

    final result = await listContacts(repository: repository);

    expect(_names(result), ['Saulo', 'Rogerr', 'Marco', 'Abel']);
  });

  test(
    'returns a failure with a friendly message when loading breaks',
    () async {
      final repository = InMemoryContactsRepository([])..isOffline = true;

      final result = await listContacts(repository: repository);

      expect((result as Failure).message, contactsLoadErrorMessage);
    },
  );
}
