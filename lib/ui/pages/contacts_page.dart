import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:app_igreja_guacui/shared/result.dart';
import 'package:app_igreja_guacui/ui/blocks/contact_list/index.dart';
import 'package:app_igreja_guacui/ui/elements/result_loader.dart';
import 'package:flutter/material.dart';

typedef LoadContacts = Future<Result<List<Contact>>> Function();

class ContactsPage extends StatelessWidget {
  const ContactsPage({required this.loadContacts, super.key});

  final LoadContacts loadContacts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contatos')),
      body: ResultLoader(
        load: loadContacts,
        loadingLabel: 'Carregando contatos',
        builder: (contacts) => ContactList(contacts: contacts),
      ),
    );
  }
}
