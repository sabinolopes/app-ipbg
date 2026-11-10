import 'package:app_igreja_guacui/ui/pages/bulletin_page.dart';
import 'package:app_igreja_guacui/ui/pages/bulletins_page.dart';
import 'package:app_igreja_guacui/ui/pages/contacts_page.dart';
import 'package:app_igreja_guacui/ui/pages/home_page.dart';
import 'package:flutter/material.dart';

const _seedColor = Color(0xFF1B5E20);

class App extends StatelessWidget {
  const App({
    required this.loadBulletins,
    required this.loadContacts,
    required this.openLink,
    super.key,
  });

  final LoadBulletins loadBulletins;
  final LoadContacts loadContacts;
  final OpenLink openLink;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Igreja Presbiteriana de Guaçuí',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
      ),
      home: HomePage(
        loadBulletins: loadBulletins,
        loadContacts: loadContacts,
        openLink: openLink,
      ),
    );
  }
}
