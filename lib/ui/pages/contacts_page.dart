import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:app_igreja_guacui/shared/result.dart';
import 'package:app_igreja_guacui/ui/blocks/contact_list/index.dart';
import 'package:app_igreja_guacui/ui/elements/loading_indicator.dart';
import 'package:app_igreja_guacui/ui/elements/message_with_action.dart';
import 'package:flutter/material.dart';

typedef LoadContacts = Future<Result<List<Contact>>> Function();

class ContactsPage extends StatefulWidget {
  const ContactsPage({required this.loadContacts, super.key});

  final LoadContacts loadContacts;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late Future<Result<List<Contact>>> _loading;

  @override
  void initState() {
    super.initState();
    _loading = widget.loadContacts();
  }

  void _retry() {
    setState(() {
      _loading = widget.loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contatos')),
      body: FutureBuilder(
        future: _loading,
        builder: (context, snapshot) {
          // On retry, FutureBuilder keeps the previous result until the new
          // one arrives; without this the old error would stay on screen.
          final isDone = snapshot.connectionState == ConnectionState.done;
          return _content(isDone ? snapshot.data : null);
        },
      ),
    );
  }

  Widget _content(Result<List<Contact>>? result) {
    return switch (result) {
      null => const LoadingIndicator(label: 'Carregando contatos'),
      Success(:final data) => ContactList(contacts: data),
      Failure(:final message) => MessageWithAction(
        message: message,
        actionLabel: 'Tentar novamente',
        onAction: _retry,
      ),
    };
  }
}
