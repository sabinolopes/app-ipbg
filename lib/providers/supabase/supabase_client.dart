import 'package:app_igreja_guacui/shared/config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<SupabaseClient> initializeSupabase() async {
  final supabase = await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );
  return supabase.client;
}
