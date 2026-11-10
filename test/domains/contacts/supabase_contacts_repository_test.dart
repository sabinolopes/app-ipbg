import 'package:app_igreja_guacui/domains/contacts/supabase_contacts_repository.dart';
import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _row({required String role}) {
  return {
    'id': 'a1',
    'name': 'Reinaldo',
    'role': role,
    'phone': '+55 28 98802-8801',
    'email': null,
    'photo_url': null,
  };
}

void main() {
  test('translates a database row into a contact', () {
    final contact = contactFromRow(_row(role: 'elder'));

    expect(contact.id, 'a1');
    expect(contact.name, 'Reinaldo');
    expect(contact.role, Role.elder);
    expect(contact.phone, '+55 28 98802-8801');
    expect(contact.email, isNull);
  });

  test('translates every role stored in the database', () {
    expect(contactFromRow(_row(role: 'pastor')).role, Role.pastor);
    expect(contactFromRow(_row(role: 'deacon')).role, Role.deacon);
  });

  test('rejects a role the app does not know', () {
    expect(() => contactFromRow(_row(role: 'bishop')), throwsFormatException);
  });
}
