import 'package:app_igreja_guacui/domains/schedule/types.dart';
import 'package:app_igreja_guacui/shared/long_date.dart';
import 'package:app_igreja_guacui/shared/result.dart';
import 'package:app_igreja_guacui/ui/blocks/appointment_request_form/index.dart';
import 'package:app_igreja_guacui/ui/elements/message_with_action.dart';
import 'package:flutter/material.dart';

const _margin = 24.0;
const _smallSpacing = 4.0;

typedef RequestAppointment = Future<Result<AppointmentRequest>> Function(
  AppointmentForm form,
);

class AppointmentRequestPage extends StatefulWidget {
  const AppointmentRequestPage({
    required this.slot,
    required this.requestAppointment,
    super.key,
  });

  final ScheduleSlot slot;
  final RequestAppointment requestAppointment;

  @override
  State<AppointmentRequestPage> createState() => _AppointmentRequestPageState();
}

class _AppointmentRequestPageState extends State<AppointmentRequestPage> {
  bool _isSubmitting = false;
  bool _wasSent = false;
  String? _errorMessage;

  Future<void> _submit(String name, String phone) async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final result = await widget.requestAppointment(
      AppointmentForm(
        slotId: widget.slot.id,
        requesterName: name,
        requesterPhone: phone,
      ),
    );
    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      _wasSent = result is Success;
      _errorMessage = _failureMessage(result);
    });
  }

  String? _failureMessage(Result<AppointmentRequest> result) {
    return switch (result) {
      Success() => null,
      Failure(:final message) => message,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar horário')),
      body: _wasSent ? _confirmation(context) : _form(context),
    );
  }

  Widget _confirmation(BuildContext context) {
    return MessageWithAction(
      message:
          'Pedido enviado! O pastor entrará em contato pelo telefone '
          'informado para confirmar.',
      actionLabel: 'Voltar para a agenda',
      onAction: () => Navigator.of(context).pop(),
    );
  }

  Widget _form(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final slot = widget.slot;

    return ListView(
      padding: const EdgeInsets.all(_margin),
      children: [
        Text(weekdayAndDay(slot.start), style: textTheme.titleLarge),
        const SizedBox(height: _smallSpacing),
        Text(timeRange(slot.start, slot.end), style: textTheme.bodyLarge),
        const SizedBox(height: _margin),
        AppointmentRequestForm(
          isSubmitting: _isSubmitting,
          errorMessage: _errorMessage,
          onSubmit: _submit,
        ),
      ],
    );
  }
}
