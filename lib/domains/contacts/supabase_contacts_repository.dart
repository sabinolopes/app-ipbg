import 'package:app_igreja_guacui/domains/contacts/contacts_repository.dart';
import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _table = 'contacts';
const _columns = 'id, name, role, phone, email, photo_url';

const _roleByDatabaseValue = {
  'pastor': Role.pastor,
  'elder': Role.elder,
  'deacon': Role.deacon,
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
    phone: row['phone'] as String?,
    email: row['email'] as String?,
    photoUrl: row['photo_url'] as String?,
  );
}
