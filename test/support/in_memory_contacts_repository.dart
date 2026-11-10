import 'package:app_igreja_guacui/domains/contacts/contacts_repository.dart';
import 'package:app_igreja_guacui/domains/contacts/types.dart';

class InMemoryContactsRepository implements ContactsRepository {
  InMemoryContactsRepository(this.contacts);

  final List<Contact> contacts;
  bool isOffline = false;

  @override
  Future<List<Contact>> list() async {
    if (isOffline) throw Exception('no connection');

    return [...contacts];
  }
}
