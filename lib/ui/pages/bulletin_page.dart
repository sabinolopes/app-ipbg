import 'package:app_igreja_guacui/domains/bulletins/types.dart';
import 'package:app_igreja_guacui/shared/long_date.dart';
import 'package:flutter/material.dart';

const _margin = 24.0;
const _spacing = 16.0;
const _smallSpacing = 4.0;

typedef OpenLink = Future<bool> Function(Uri link);

class BulletinPage extends StatelessWidget {
  const BulletinPage({
    required this.bulletin,
    required this.openLink,
    super.key,
  });

  final Bulletin bulletin;
  final OpenLink openLink;

  Future<void> _openPdf(BuildContext context, Uri pdfLink) async {
    // Read before the await: the page may be gone when the link returns.
    final messenger = ScaffoldMessenger.of(context);

    final wasOpened = await openLink(pdfLink);
    if (wasOpened) return;

    messenger.showSnackBar(
      const SnackBar(content: Text('Não foi possível abrir o PDF.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final content = bulletin.content;
    final pdfLink = bulletin.pdfLink;

    return Scaffold(
      appBar: AppBar(title: const Text('Boletim')),
      body: ListView(
        padding: const EdgeInsets.all(_margin),
        children: [
          Text(bulletin.title, style: textTheme.headlineSmall),
          const SizedBox(height: _smallSpacing),
          Text(longDate(bulletin.publicationDate), style: textTheme.bodySmall),
          if (content != null) ...[
            const SizedBox(height: _spacing),
            Text(content, style: textTheme.bodyLarge),
          ],
          if (pdfLink != null) ...[
            const SizedBox(height: _margin),
            FilledButton.icon(
              onPressed: () => _openPdf(context, pdfLink),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Abrir PDF'),
            ),
          ],
        ],
      ),
    );
  }
}
