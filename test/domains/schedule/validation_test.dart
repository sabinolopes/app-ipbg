import 'package:app_igreja_guacui/domains/schedule/types.dart';
import 'package:app_igreja_guacui/domains/schedule/validation.dart';
import 'package:app_igreja_guacui/shared/result.dart';
import 'package:flutter_test/flutter_test.dart';

AppointmentForm _form({required String name, required String phone}) {
  return AppointmentForm(
    slotId: 'slot-1',
    requesterName: name,
    requesterPhone: phone,
  );
}

void main() {
  group('name', () {
    test('requires a name, even when only spaces were typed', () {
      expect(requesterNameError(''), 'Informe seu nome.');
      expect(requesterNameError('   '), 'Informe seu nome.');
    });

    test('accepts from 3 to 80 letters', () {
      expect(requesterNameError('Jó'), isNotNull);
      expect(requesterNameError('Ana'), isNull);
      expect(requesterNameError('a' * 80), isNull);
      expect(requesterNameError('a' * 81), isNotNull);
    });

    test('ignores extra spaces when measuring and cleaning', () {
      expect(requesterNameError(' a  b '), isNull);
      expect(cleanRequesterName('  Maria   da  Silva '), 'Maria da Silva');
    });
  });

  group('phone', () {
    test('requires a phone', () {
      expect(requesterPhoneError(''), 'Informe seu telefone.');
      expect(requesterPhoneError('( ) -'), 'Informe seu telefone.');
    });

    test('accepts landline and mobile numbers with area code', () {
      expect(requesterPhoneError('(28) 3553-0000'), isNull);
      expect(requesterPhoneError('(28) 99999-0000'), isNull);
    });

    test('rejects numbers without area code or with extra digits', () {
      expect(requesterPhoneError('99999-0000'), isNotNull);
      expect(requesterPhoneError('28 99999-00001'), isNotNull);
    });

    test('keeps only the digits and drops the country code', () {
      expect(cleanRequesterPhone('(28) 99999-0000'), '28999990000');
      expect(cleanRequesterPhone('+55 28 99999-0000'), '28999990000');
      expect(cleanRequesterPhone('+55 (28) 3553-0000'), '2835530000');
    });

    test('keeps 55 when it is the area code', () {
      expect(cleanRequesterPhone('(55) 99999-0000'), '55999990000');
      expect(requesterPhoneError('(55) 99999-0000'), isNull);
    });
  });

  group('form', () {
    test('returns the cleaned request when everything is valid', () {
      final result = validateAppointmentForm(
        _form(name: '  Maria  Silva ', phone: '+55 (28) 99999-0000'),
      );

      final request = (result as Success<AppointmentRequest>).data;
      expect(request.slotId, 'slot-1');
      expect(request.requesterName, 'Maria Silva');
      expect(request.requesterPhone, '28999990000');
    });

    test('reports the name problem before the phone problem', () {
      final result = validateAppointmentForm(_form(name: '', phone: ''));

      expect((result as Failure).message, 'Informe seu nome.');
    });

    test('reports the phone problem when the name is fine', () {
      final result = validateAppointmentForm(_form(name: 'Maria', phone: '9'));

      expect((result as Failure).message, contains('DDD'));
    });
  });
}
