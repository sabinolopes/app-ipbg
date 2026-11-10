import 'package:app_igreja_guacui/domains/schedule/validation.dart';
import 'package:flutter/material.dart';

const _spacing = 16.0;

typedef SubmitRequester = void Function(String name, String phone);

class AppointmentRequestForm extends StatefulWidget {
  const AppointmentRequestForm({
    required this.isSubmitting,
    required this.onSubmit,
    this.errorMessage,
    super.key,
  });

  final bool isSubmitting;
  final SubmitRequester onSubmit;
  final String? errorMessage;

  @override
  State<AppointmentRequestForm> createState() => _AppointmentRequestFormState();
}

class _AppointmentRequestFormState extends State<AppointmentRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    widget.onSubmit(_nameController.text, _phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = widget.errorMessage;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Seu nome'),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: (name) => requesterNameError(name ?? ''),
          ),
          const SizedBox(height: _spacing),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Telefone com DDD',
              hintText: '(28) 99999-0000',
            ),
            keyboardType: TextInputType.phone,
            validator: (phone) => requesterPhoneError(phone ?? ''),
          ),
          const SizedBox(height: _spacing),
          const Text('Seu nome e telefone são enviados apenas ao pastor.'),
          if (errorMessage != null) ...[
            const SizedBox(height: _spacing),
            _SubmitError(errorMessage),
          ],
          const SizedBox(height: _spacing),
          FilledButton(
            onPressed: widget.isSubmitting ? null : _submit,
            child: Text(widget.isSubmitting ? 'Enviando...' : 'Enviar pedido'),
          ),
        ],
      ),
    );
  }
}

class _SubmitError extends StatelessWidget {
  const _SubmitError(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
