import 'package:app_igreja_guacui/domains/bulletins/types.dart';
import 'package:app_igreja_guacui/shared/long_date.dart';
import 'package:flutter/material.dart';

class BulletinList extends StatelessWidget {
  const BulletinList({
    required this.bulletins,
    required this.onSelect,
    super.key,
  });

  final List<Bulletin> bulletins;
  final ValueChanged<Bulletin> onSelect;

  @override
  Widget build(BuildContext context) {
    if (bulletins.isEmpty) {
      return const Center(child: Text('Nenhum boletim publicado ainda.'));
    }

    return ListView.separated(
      itemCount: bulletins.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => _bulletinItem(bulletins[index]),
    );
  }

  Widget _bulletinItem(Bulletin bulletin) {
    return ListTile(
      title: Text(bulletin.title),
      subtitle: Text(longDate(bulletin.publicationDate)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => onSelect(bulletin),
    );
  }
}
