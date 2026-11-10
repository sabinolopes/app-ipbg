import 'package:app_igreja_guacui/domains/schedule/types.dart';
import 'package:app_igreja_guacui/shared/result.dart';

// These limits are also enforced by check constraints in the database.
const _minimumNameLength = 3;
const _maximumNameLength = 80;
const _landlinePhoneLength = 10;
const _mobilePhoneLength = 11;
const _countryCode = '55';

final _repeatedSpaces = RegExp(r'\s+');
final _nonDigits = RegExp(r'\D');

String cleanRequesterName(String name) {
  return name.trim().replaceAll(_repeatedSpaces, ' ');
}

/// Keeps only the digits of area code + number.
String cleanRequesterPhone(String phone) {
  final digits = phone.replaceAll(_nonDigits, '');
  // 55 is also an area code, so it is only the country code when the number
  // is longer than a mobile number.
  final hasCountryCode =
      digits.startsWith(_countryCode) && digits.length > _mobilePhoneLength;
  if (!hasCountryCode) return digits;

  return digits.substring(_countryCode.length);
}

String? requesterNameError(String name) {
  final cleanName = cleanRequesterName(name);
  if (cleanName.isEmpty) return 'Informe seu nome.';
  if (cleanName.length < _minimumNameLength) {
    return 'O nome precisa ter pelo menos $_minimumNameLength letras.';
  }
  if (cleanName.length > _maximumNameLength) {
    return 'O nome pode ter no máximo $_maximumNameLength letras.';
  }

  return null;
}

String? requesterPhoneError(String phone) {
  final cleanPhone = cleanRequesterPhone(phone);
  if (cleanPhone.isEmpty) return 'Informe seu telefone.';

  final hasValidLength =
      cleanPhone.length == _landlinePhoneLength ||
      cleanPhone.length == _mobilePhoneLength;
  if (!hasValidLength) {
    return 'Informe o telefone com DDD, por exemplo (28) 99999-0000.';
  }

  return null;
}

Result<AppointmentRequest> validateAppointmentForm(AppointmentForm form) {
  final error =
      requesterNameError(form.requesterName) ??
      requesterPhoneError(form.requesterPhone);
  if (error != null) return Failure(error);

  return Success(
    AppointmentRequest(
      slotId: form.slotId,
      requesterName: cleanRequesterName(form.requesterName),
      requesterPhone: cleanRequesterPhone(form.requesterPhone),
    ),
  );
}
