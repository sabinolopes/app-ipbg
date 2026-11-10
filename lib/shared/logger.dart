import 'dart:developer' as developer;

const _logName = 'app_igreja_guacui';

// "SEVERE" in the Dart logging convention.
const _errorLevel = 1000;

/// Logs a technical error. Never include a name, phone number or any other
/// personal data in the message.
void logError(String message, {required Object error, StackTrace? stackTrace}) {
  developer.log(
    message,
    name: _logName,
    level: _errorLevel,
    error: error,
    stackTrace: stackTrace,
  );
}
