import 'package:app_igreja_guacui/shared/logger.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the link in a browser view on top of the app, so the user comes back
/// to the same screen when closing it. Returns whether it could be opened.
Future<bool> openLinkInApp(Uri link) async {
  try {
    return await launchUrl(link, mode: LaunchMode.inAppBrowserView);
  } on PlatformException catch (error, stackTrace) {
    logError('Failed to open link', error: error, stackTrace: stackTrace);
    return false;
  }
}
