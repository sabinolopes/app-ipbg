import 'package:app_igreja_guacui/domains/bulletins/bulletins_repository.dart';
import 'package:app_igreja_guacui/domains/bulletins/types.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _table = 'bulletins';
const _columns = 'id, title, content, pdf_url, publication_date';

class SupabaseBulletinsRepository implements BulletinsRepository {
  const SupabaseBulletinsRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Bulletin>> list() async {
    final rows = await _client.from(_table).select(_columns);
    return rows.map(bulletinFromRow).toList();
  }
}

Bulletin bulletinFromRow(Map<String, dynamic> row) {
  return Bulletin(
    id: row['id'] as String,
    title: row['title'] as String,
    publicationDate: DateTime.parse(row['publication_date'] as String),
    content: _textOrNull(row['content'] as String?),
    pdfLink: safePdfLink(row['pdf_url'] as String?),
  );
}

// A content cell cleared in the Table Editor can come back as an empty text
// instead of null.
String? _textOrNull(String? text) {
  final trimmedText = text?.trim() ?? '';
  if (trimmedText.isEmpty) return null;

  return trimmedText;
}
