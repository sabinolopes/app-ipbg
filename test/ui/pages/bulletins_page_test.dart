import 'package:app_igreja_guacui/domains/bulletins/bulletins_service.dart';
import 'package:app_igreja_guacui/domains/bulletins/types.dart';
import 'package:app_igreja_guacui/ui/pages/bulletins_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_bulletins_repository.dart';

final _pdfLink = Uri.parse('https://example.com/boletim.pdf');

final _bulletinWithPdf = Bulletin(
  id: '1',
  title: 'Boletim de agosto',
  publicationDate: DateTime(2026, 8, 24),
  content: 'Avisos da semana',
  pdfLink: _pdfLink,
);

final _bulletinWithoutPdf = Bulletin(
  id: '2',
  title: 'Boletim sem anexo',
  publicationDate: DateTime(2026, 8, 17),
);

class _LinkOpener {
  _LinkOpener({required this.canOpen});

  final bool canOpen;
  final List<Uri> openedLinks = [];

  Future<bool> open(Uri link) async {
    if (canOpen) openedLinks.add(link);

    return canOpen;
  }
}

Future<void> _openPage(
  WidgetTester tester, {
  required InMemoryBulletinsRepository repository,
  _LinkOpener? linkOpener,
}) async {
  final opener = linkOpener ?? _LinkOpener(canOpen: true);
  await tester.pumpWidget(
    MaterialApp(
      home: BulletinsPage(
        loadBulletins: () => listBulletins(repository: repository),
        openLink: opener.open,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openBulletin(WidgetTester tester, String title) async {
  await tester.tap(find.text(title));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists the bulletins with their publication dates', (
    tester,
  ) async {
    await _openPage(
      tester,
      repository: InMemoryBulletinsRepository([_bulletinWithPdf]),
    );

    expect(find.text('Boletim de agosto'), findsOneWidget);
    expect(find.text('24 de agosto de 2026'), findsOneWidget);
  });

  testWidgets('tells the user when there are no bulletins', (tester) async {
    await _openPage(tester, repository: InMemoryBulletinsRepository([]));

    expect(find.text('Nenhum boletim publicado ainda.'), findsOneWidget);
  });

  testWidgets('shows the error when loading breaks', (tester) async {
    await _openPage(
      tester,
      repository: InMemoryBulletinsRepository([])..isOffline = true,
    );

    expect(find.text(bulletinsLoadErrorMessage), findsOneWidget);
  });

  testWidgets('opens a bulletin and its PDF', (tester) async {
    final linkOpener = _LinkOpener(canOpen: true);
    await _openPage(
      tester,
      repository: InMemoryBulletinsRepository([_bulletinWithPdf]),
      linkOpener: linkOpener,
    );

    await _openBulletin(tester, 'Boletim de agosto');
    expect(find.text('Avisos da semana'), findsOneWidget);

    await tester.tap(find.text('Abrir PDF'));
    await tester.pumpAndSettle();

    expect(linkOpener.openedLinks, [_pdfLink]);
    expect(find.text('Não foi possível abrir o PDF.'), findsNothing);
  });

  testWidgets('warns the user when the PDF cannot be opened', (tester) async {
    await _openPage(
      tester,
      repository: InMemoryBulletinsRepository([_bulletinWithPdf]),
      linkOpener: _LinkOpener(canOpen: false),
    );

    await _openBulletin(tester, 'Boletim de agosto');
    await tester.tap(find.text('Abrir PDF'));
    await tester.pumpAndSettle();

    expect(find.text('Não foi possível abrir o PDF.'), findsOneWidget);
  });

  testWidgets('hides the PDF button when the bulletin has no PDF', (
    tester,
  ) async {
    await _openPage(
      tester,
      repository: InMemoryBulletinsRepository([_bulletinWithoutPdf]),
    );

    await _openBulletin(tester, 'Boletim sem anexo');

    expect(find.text('Boletim sem anexo'), findsOneWidget);
    expect(find.text('Abrir PDF'), findsNothing);
  });
}
