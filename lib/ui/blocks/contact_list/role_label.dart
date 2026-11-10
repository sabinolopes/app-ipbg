import 'package:app_igreja_guacui/domains/contacts/types.dart';

String roleLabel(Role role) {
  return switch (role) {
    Role.pastor => 'Pastor',
    Role.elder => 'Presbítero',
    Role.deacon => 'Diácono',
  };
}
