import 'package:app_igreja_guacui/domains/schedule/supabase_schedule_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('joins the date and the times of a row into a slot', () {
    final slot = slotFromRow({
      'id': 's1',
      'date': '2026-11-17',
      'start_time': '14:00:00',
      'end_time': '15:30:00',
    });

    expect(slot.id, 's1');
    expect(slot.start, DateTime(2026, 11, 17, 14));
    expect(slot.end, DateTime(2026, 11, 17, 15, 30));
  });

  test('recognizes the database refusals that mean the slot is taken', () {
    expect(isSlotUnavailableError('P0001'), isTrue);
    expect(isSlotUnavailableError('23505'), isTrue);
  });

  test('does not blame the slot for other database errors', () {
    expect(isSlotUnavailableError('23514'), isFalse);
    expect(isSlotUnavailableError('42501'), isFalse);
    expect(isSlotUnavailableError(null), isFalse);
  });
}
