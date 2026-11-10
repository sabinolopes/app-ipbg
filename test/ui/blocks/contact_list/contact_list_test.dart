import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:app_igreja_guacui/ui/blocks/contact_list/contact_list.dart';
import 'package:app_igreja_guacui/ui/blocks/contact_list/role_label.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shows the role in Portuguese', () {
    expect(roleLabel(Role.pastor), 'Pastor');
    expect(roleLabel(Role.elder), 'Presbítero');
    expect(roleLabel(Role.deacon), 'Diácono');
  });

  test('joins role and phone in the contact details', () {
    const contact = Contact(
      id: '1',
      name: 'Rinaldo',
      role: Role.pastor,
      phone: '+55 27 99994-9911',
    );

    expect(contactDetails(contact), 'Pastor · +55 27 99994-9911');
  });

  test('shows only the role when the contact has no phone', () {
    const contact = Contact(id: '1', name: 'Davi', role: Role.deacon);

    expect(contactDetails(contact), 'Diácono');
  });
}
