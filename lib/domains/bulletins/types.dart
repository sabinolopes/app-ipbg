const _allowedLinkScheme = 'https';

class Bulletin {
  const Bulletin({
    required this.id,
    required this.title,
    required this.publicationDate,
    this.content,
    this.pdfLink,
  });

  final String id;
  final String title;
  final DateTime publicationDate;
  final String? content;
  final Uri? pdfLink;
}

List<Bulletin> sortBulletins(List<Bulletin> bulletins) {
  return [...bulletins]..sort(
    (first, second) => second.publicationDate.compareTo(first.publicationDate),
  );
}

/// The link comes from the database and is opened by the app, so anything
/// that is not a plain https address is treated as if there were no PDF.
Uri? safePdfLink(String? address) {
  if (address == null) return null;

  final link = Uri.tryParse(address.trim());
  if (link == null || link.host.isEmpty) return null;
  if (link.scheme != _allowedLinkScheme) return null;

  return link;
}
