import 'package:app_igreja_guacui/ui/pages/contacts_page.dart';
import 'package:flutter/material.dart';

const _seedColor = Color(0xFF1B5E20);

class App extends StatelessWidget {
  const App({required this.loadContacts, super.key});

  final LoadContacts loadContacts;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Igreja Presbiteriana de Guaçuí',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
      ),
      home: ContactsPage(loadContacts: loadContacts),
    );
  }
}
