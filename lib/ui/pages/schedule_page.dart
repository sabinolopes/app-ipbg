import 'package:app_igreja_guacui/domains/schedule/types.dart';
import 'package:app_igreja_guacui/shared/result.dart';
import 'package:app_igreja_guacui/ui/blocks/slot_list/index.dart';
import 'package:app_igreja_guacui/ui/elements/result_loader.dart';
import 'package:app_igreja_guacui/ui/pages/appointment_request_page.dart';
import 'package:flutter/material.dart';

typedef LoadAvailableSlots = Future<Result<List<ScheduleSlot>>> Function();

class SchedulePage extends StatefulWidget {
  const SchedulePage({
    required this.loadAvailableSlots,
    required this.requestAppointment,
    super.key,
  });

  final LoadAvailableSlots loadAvailableSlots;
  final RequestAppointment requestAppointment;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _reloadCount = 0;

  Future<void> _requestSlot(ScheduleSlot slot) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => AppointmentRequestPage(
          slot: slot,
          requestAppointment: widget.requestAppointment,
        ),
      ),
    );
    if (!mounted) return;

    // The slot may have been taken, by this user or by someone else.
    setState(() {
      _reloadCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda do pastor')),
      body: ResultLoader(
        // A new key discards the loader state, which makes it load again.
        key: ValueKey(_reloadCount),
        load: widget.loadAvailableSlots,
        loadingLabel: 'Carregando horários',
        builder: (slots) => SlotList(slots: slots, onSelect: _requestSlot),
      ),
    );
  }
}
