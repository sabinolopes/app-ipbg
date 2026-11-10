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

  test('names the weekday of a date', () {
    expect(
      weekdayAndDay(DateTime(2026, 11, 17)),
      'terça-feira, 17 de novembro',
    );
    expect(
      weekdayAndDay(DateTime(2026, 11, 16)),
      'segunda-feira, 16 de novembro',
    );
    expect(weekdayAndDay(DateTime(2026, 11, 22)), 'domingo, 22 de novembro');
  });

  test('writes a time range with two-digit hours and minutes', () {
    final start = DateTime(2026, 11, 17, 9, 5);
    final end = DateTime(2026, 11, 17, 10);

    expect(timeRange(start, end), '09:05 às 10:00');
  });
}
