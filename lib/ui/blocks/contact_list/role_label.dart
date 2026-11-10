import 'package:app_igreja_guacui/domains/contacts/types.dart';

const _labelSeparator = ' · ';

String roleLabel(Role role) {
  return switch (role) {
    Role.pastor => 'Pastor',
    Role.elder => 'Presbítero',
    Role.deacon => 'Diácono',
  };
}

/// "Presbítero · Vice-Presidente do Conselho", or just the role when the
/// contact has no position on the board.
String roleDescription(Contact contact) {
  final boardPosition = contact.boardPosition;
  if (boardPosition == null) return roleLabel(contact.role);

  final positionLabel =
      '${_boardPositionLabel(boardPosition)} ${_boardName(contact.role)}';
  return [roleLabel(contact.role), positionLabel].join(_labelSeparator);
}

String _boardPositionLabel(BoardPosition boardPosition) {
  return switch (boardPosition) {
    BoardPosition.president => 'Presidente',
    BoardPosition.vicePresident => 'Vice-Presidente',
    BoardPosition.firstSecretary => '1º Secretário',
    BoardPosition.secondSecretary => '2º Secretário',
  };
}

String _boardName(Role role) {
  return switch (role) {
    Role.pastor || Role.elder => 'do Conselho',
    Role.deacon => 'da Junta Diaconal',
  };
}
