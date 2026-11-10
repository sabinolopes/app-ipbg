import 'package:app_igreja_guacui/app.dart';
import 'package:app_igreja_guacui/domains/contacts/contacts_service.dart';
import 'package:app_igreja_guacui/domains/contacts/supabase_contacts_repository.dart';
import 'package:app_igreja_guacui/providers/supabase/supabase_client.dart';
import 'package:flutter/material.dart';

// Entry point: this is where the real implementations are chosen and handed
// to the services. The rest of the app only knows the interfaces.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabaseClient = await initializeSupabase();
  final contactsRepository = SupabaseContactsRepository(supabaseClient);

  runApp(App(loadContacts: () => listContacts(repository: contactsRepository)));
}
