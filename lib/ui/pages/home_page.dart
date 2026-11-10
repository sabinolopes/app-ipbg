import 'package:app_igreja_guacui/app_dependencies.dart';
import 'package:app_igreja_guacui/ui/pages/bulletins_page.dart';
import 'package:app_igreja_guacui/ui/pages/contacts_page.dart';
import 'package:app_igreja_guacui/ui/pages/schedule_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.dependencies, super.key});

  final AppDependencies dependencies;

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
    final dependencies = widget.dependencies;
    // Only the selected section is built, so each visit loads fresh data.
    final sections = [
      BulletinsPage(
        loadBulletins: dependencies.loadBulletins,
        openLink: dependencies.openLink,
      ),
      SchedulePage(
        loadAvailableSlots: dependencies.loadAvailableSlots,
        requestAppointment: dependencies.requestAppointment,
      ),
      ContactsPage(loadContacts: dependencies.loadContacts),
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
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: 'Agenda',
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
