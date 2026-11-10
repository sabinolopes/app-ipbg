import 'package:app_igreja_guacui/ui/pages/appointment_request_page.dart';
import 'package:app_igreja_guacui/ui/pages/bulletin_page.dart';
import 'package:app_igreja_guacui/ui/pages/bulletins_page.dart';
import 'package:app_igreja_guacui/ui/pages/contacts_page.dart';
import 'package:app_igreja_guacui/ui/pages/schedule_page.dart';

/// Everything the screens need from outside the interface. Built once in
/// main.dart with the real implementations, and in tests with in-memory ones.
class AppDependencies {
  const AppDependencies({
    required this.loadBulletins,
    required this.loadContacts,
    required this.loadAvailableSlots,
    required this.requestAppointment,
    required this.openLink,
  });

  final LoadBulletins loadBulletins;
  final LoadContacts loadContacts;
  final LoadAvailableSlots loadAvailableSlots;
  final RequestAppointment requestAppointment;
  final OpenLink openLink;
}
