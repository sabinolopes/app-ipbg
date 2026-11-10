import 'package:app_igreja_guacui/domains/contacts/contacts_repository.dart';
import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _table = 'contacts';
const _columns = 'id, name, role, board_position, phone, email, photo_url';

const _roleByDatabaseValue = {
  'pastor': Role.pastor,
  'elder': Role.elder,
  'deacon': Role.deacon,
};

const _boardPositionByDatabaseValue = {
  'president': BoardPosition.president,
  'vice_president': BoardPosition.vicePresident,
  'first_secretary': BoardPosition.firstSecretary,
  'second_secretary': BoardPosition.secondSecretary,
};

class SupabaseContactsRepository implements ContactsRepository {
  const SupabaseContactsRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Contact>> list() async {
    final rows = await _client.from(_table).select(_columns);
    return rows.map(contactFromRow).toList();
  }
}

Contact contactFromRow(Map<String, dynamic> row) {
  final roleValue = row['role'] as String;
  final role = _roleByDatabaseValue[roleValue];
  if (role == null) {
    throw FormatException('Unknown role in the database: $roleValue');
  }

  return Contact(
    id: row['id'] as String,
    name: row['name'] as String,
    role: role,
    boardPosition: _boardPositionFromValue(row['board_position'] as String?),
    phone: row['phone'] as String?,
    email: row['email'] as String?,
    photoUrl: row['photo_url'] as String?,
  );
}

BoardPosition? _boardPositionFromValue(String? value) {
  if (value == null) return null;

  final boardPosition = _boardPositionByDatabaseValue[value];
  if (boardPosition == null) {
    throw FormatException('Unknown board position in the database: $value');
  }

  return boardPosition;
}
