import 'package:app_igreja_guacui/domains/bulletins/supabase_bulletins_repository.dart';
import 'package:app_igreja_guacui/domains/bulletins/types.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _row({String? content, String? pdfUrl}) {
  return {
    'id': 'b1',
    'title': 'Boletim de agosto',
    'content': content,
    'pdf_url': pdfUrl,
    'publication_date': '2026-08-24',
  };
}

void main() {
  test('translates a database row into a bulletin', () {
    final bulletin = bulletinFromRow(
      _row(content: 'Avisos da semana', pdfUrl: 'https://example.com/b.pdf'),
    );

    expect(bulletin.id, 'b1');
    expect(bulletin.title, 'Boletim de agosto');
    expect(bulletin.publicationDate, DateTime(2026, 8, 24));
    expect(bulletin.content, 'Avisos da semana');
    expect(bulletin.pdfLink, Uri.parse('https://example.com/b.pdf'));
  });

  test('treats missing or blank content as no content', () {
    expect(bulletinFromRow(_row()).content, isNull);
    expect(bulletinFromRow(_row(content: '   ')).content, isNull);
  });

  test('accepts only https addresses as the PDF link', () {
    expect(safePdfLink(' https://example.com/b.pdf '), isNotNull);
    expect(safePdfLink('http://example.com/b.pdf'), isNull);
    expect(safePdfLink('javascript:alert(1)'), isNull);
    expect(safePdfLink('tel:+5527999999999'), isNull);
    expect(safePdfLink('boletim.pdf'), isNull);
    expect(safePdfLink(''), isNull);
    expect(safePdfLink(null), isNull);
  });
}
