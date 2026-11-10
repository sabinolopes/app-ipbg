import 'package:app_igreja_guacui/shared/long_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('writes the date the way it is read in Portuguese', () {
    expect(longDate(DateTime(2026, 8, 24)), '24 de agosto de 2026');
  });

  test('covers the first and the last month, without padding the day', () {
    expect(longDate(DateTime(2027, 1, 3)), '3 de janeiro de 2027');
    expect(longDate(DateTime(2026, 12, 31)), '31 de dezembro de 2026');
  });
}
