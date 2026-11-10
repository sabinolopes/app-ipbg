import 'package:app_igreja_guacui/domains/contacts/types.dart';

abstract interface class ContactsRepository {
  Future<List<Contact>> list();
}
