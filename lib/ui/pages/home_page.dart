import 'package:app_igreja_guacui/ui/pages/bulletin_page.dart';
import 'package:app_igreja_guacui/ui/pages/bulletins_page.dart';
import 'package:app_igreja_guacui/ui/pages/contacts_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.loadBulletins,
    required this.loadContacts,
    required this.openLink,
    super.key,
  });

  final LoadBulletins loadBulletins;
  final LoadContacts loadContacts;
  final OpenLink openLink;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _selectSection(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only the selected section is built, so each visit loads fresh data.
    final sections = [
      BulletinsPage(
        loadBulletins: widget.loadBulletins,
        openLink: widget.openLink,
      ),
      ContactsPage(loadContacts: widget.loadContacts),
    ];

    return Scaffold(
      body: sections[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectSection,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Boletins',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Contatos',
          ),
        ],
      ),
    );
  }
}
