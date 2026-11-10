import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:app_igreja_guacui/ui/blocks/contact_list/role_label.dart';
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  const ContactList({required this.contacts, super.key});

  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return const Center(child: Text('Nenhum contato cadastrado ainda.'));
    }

    return ListView.separated(
      itemCount: contacts.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => _ContactItem(contacts[index]),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem(this.contact);

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final phone = contact.phone;

    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(contact.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(roleDescription(contact)), ?_phoneText(phone)],
      ),
    );
  }

  Widget? _phoneText(String? phone) {
    if (phone == null) return null;

    return Text(phone);
  }
}
