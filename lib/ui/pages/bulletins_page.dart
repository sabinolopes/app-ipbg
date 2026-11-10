import 'package:app_igreja_guacui/domains/bulletins/types.dart';
import 'package:app_igreja_guacui/shared/result.dart';
import 'package:app_igreja_guacui/ui/blocks/bulletin_list/index.dart';
import 'package:app_igreja_guacui/ui/elements/result_loader.dart';
import 'package:app_igreja_guacui/ui/pages/bulletin_page.dart';
import 'package:flutter/material.dart';

typedef LoadBulletins = Future<Result<List<Bulletin>>> Function();

class BulletinsPage extends StatelessWidget {
  const BulletinsPage({
    required this.loadBulletins,
    required this.openLink,
    super.key,
  });

  final LoadBulletins loadBulletins;
  final OpenLink openLink;

  void _openBulletin(BuildContext context, Bulletin bulletin) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            BulletinPage(bulletin: bulletin, openLink: openLink),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boletins')),
      body: ResultLoader(
        load: loadBulletins,
        loadingLabel: 'Carregando boletins',
        builder: (bulletins) => BulletinList(
          bulletins: bulletins,
          onSelect: (bulletin) => _openBulletin(context, bulletin),
        ),
      ),
    );
  }
}
