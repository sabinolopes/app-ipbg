import 'package:app_igreja_guacui/domains/schedule/schedule_service.dart';
import 'package:app_igreja_guacui/domains/schedule/types.dart';
import 'package:app_igreja_guacui/ui/pages/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/in_memory_schedule_repository.dart';

const _slotLabel = 'terça-feira, 17 de novembro';

final _now = DateTime(2026, 11, 10, 12);
final _slot = ScheduleSlot(
  id: 'slot-1',
  start: DateTime(2026, 11, 17, 14),
  end: DateTime(2026, 11, 17, 15),
);

Future<InMemoryScheduleRepository> _openPage(WidgetTester tester) async {
  final repository = InMemoryScheduleRepository([_slot]);
  await tester.pumpWidget(
    MaterialApp(
      home: SchedulePage(
        loadAvailableSlots: () =>
            listAvailableSlots(repository: repository, now: _now),
        requestAppointment: (form) =>
            requestAppointment(repository: repository, form: form),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

Future<void> _fillAndSend(
  WidgetTester tester, {
  required String name,
  required String phone,
}) async {
  await tester.enterText(find.widgetWithText(TextFormField, 'Seu nome'), name);
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Telefone com DDD'),
    phone,
  );
  await tester.tap(find.text('Enviar pedido'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists the available slots with day and time', (tester) async {
    await _openPage(tester);

    expect(find.text(_slotLabel), findsOneWidget);
    expect(find.text('14:00 às 15:00'), findsOneWidget);
  });

  testWidgets('sends a request and removes the slot from the list', (
    tester,
  ) async {
    final repository = await _openPage(tester);

    await tester.tap(find.text(_slotLabel));
    await tester.pumpAndSettle();
    await _fillAndSend(tester, name: 'Maria Silva', phone: '(28) 99999-0000');

    expect(find.textContaining('Pedido enviado!'), findsOneWidget);
    expect(repository.appointments.single.requesterPhone, '28999990000');

    await tester.tap(find.text('Voltar para a agenda'));
    await tester.pumpAndSettle();

    expect(find.text(_slotLabel), findsNothing);
    expect(find.text('Nenhum horário disponível no momento.'), findsOneWidget);
  });

  testWidgets('points out invalid fields without sending anything', (
    tester,
  ) async {
    final repository = await _openPage(tester);

    await tester.tap(find.text(_slotLabel));
    await tester.pumpAndSettle();
    await _fillAndSend(tester, name: '', phone: '9999');

    expect(find.text('Informe seu nome.'), findsOneWidget);
    expect(find.textContaining('telefone com DDD'), findsOneWidget);
    expect(repository.appointments, isEmpty);
  });

  testWidgets('warns when someone else took the slot first', (tester) async {
    final repository = await _openPage(tester);

    await tester.tap(find.text(_slotLabel));
    await tester.pumpAndSettle();
    repository.reserve(_slot.id);
    await _fillAndSend(tester, name: 'Maria Silva', phone: '(28) 99999-0000');

    expect(find.text(slotUnavailableMessage), findsOneWidget);
    expect(find.textContaining('Pedido enviado!'), findsNothing);
    expect(repository.appointments, isEmpty);
  });
}
