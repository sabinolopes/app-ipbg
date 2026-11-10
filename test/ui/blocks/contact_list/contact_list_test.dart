import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:app_igreja_guacui/ui/blocks/contact_list/role_label.dart';
import 'package:flutter_test/flutter_test.dart';

Contact _contact(Role role, {BoardPosition? boardPosition}) {
  return Contact(
    id: '1',
    name: 'Nome',
    role: role,
    boardPosition: boardPosition,
  );
}

void main() {
  test('shows the role in Portuguese', () {
    expect(roleLabel(Role.pastor), 'Pastor');
    expect(roleLabel(Role.elder), 'Presbítero');
    expect(roleLabel(Role.deacon), 'Diácono');
  });

  test('shows only the role when the contact has no board position', () {
    expect(roleDescription(_contact(Role.deacon)), 'Diácono');
  });

  test('names the Conselho for the pastor and the elders', () {
    expect(
      roleDescription(
        _contact(Role.pastor, boardPosition: BoardPosition.president),
      ),
      'Pastor · Presidente do Conselho',
    );
    expect(
      roleDescription(
        _contact(Role.elder, boardPosition: BoardPosition.firstSecretary),
      ),
      'Presbítero · 1º Secretário do Conselho',
    );
  });

  test('names the Junta Diaconal for the deacons', () {
    expect(
      roleDescription(
        _contact(Role.deacon, boardPosition: BoardPosition.vicePresident),
      ),
      'Diácono · Vice-Presidente da Junta Diaconal',
    );
    expect(
      roleDescription(
        _contact(Role.deacon, boardPosition: BoardPosition.secondSecretary),
      ),
      'Diácono · 2º Secretário da Junta Diaconal',
    );
  });
}
