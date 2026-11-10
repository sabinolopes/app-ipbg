import 'package:app_igreja_guacui/domains/bulletins/bulletins_service.dart';
import 'package:app_igreja_guacui/domains/bulletins/types.dart';
import 'package:app_igreja_guacui/shared/result.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_bulletins_repository.dart';

Bulletin _bulletin(String title, DateTime publicationDate) {
  return Bulletin(id: title, title: title, publicationDate: publicationDate);
}

void main() {
  test('lists the most recent bulletin first', () async {
    final repository = InMemoryBulletinsRepository([
      _bulletin('middle', DateTime(2026, 8, 24)),
      _bulletin('oldest', DateTime(2025, 12, 28)),
      _bulletin('newest', DateTime(2026, 8, 31)),
    ]);

    final result = await listBulletins(repository: repository);

    final titles = (result as Success<List<Bulletin>>).data.map(
      (bulletin) => bulletin.title,
    );
    expect(titles, ['newest', 'middle', 'oldest']);
  });

  test(
    'returns a failure with a friendly message when loading breaks',
    () async {
      final repository = InMemoryBulletinsRepository([])..isOffline = true;

      final result = await listBulletins(repository: repository);

      expect((result as Failure).message, bulletinsLoadErrorMessage);
    },
  );
}
