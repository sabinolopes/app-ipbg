import 'package:app_igreja_guacui/domains/schedule/schedule_repository.dart';
import 'package:app_igreja_guacui/domains/schedule/types.dart';
import 'package:app_igreja_guacui/domains/schedule/validation.dart';
import 'package:app_igreja_guacui/shared/logger.dart';
import 'package:app_igreja_guacui/shared/result.dart';

const slotsLoadErrorMessage =
    'Não foi possível carregar os horários. '
    'Verifique sua conexão e tente novamente.';
const slotUnavailableMessage =
    'Esse horário acabou de ser reservado. Volte e escolha outro.';
const appointmentNotSentMessage =
    'Não foi possível enviar o pedido. '
    'Verifique sua conexão e tente novamente.';

Future<Result<List<ScheduleSlot>>> listAvailableSlots({
  required ScheduleRepository repository,
  required DateTime now,
}) async {
  try {
    final slots = await repository.listAvailableSlots();
    return Success(upcomingSlots(slots, now: now));
  } on Exception catch (error, stackTrace) {
    logError('Failed to list slots', error: error, stackTrace: stackTrace);
    return const Failure(slotsLoadErrorMessage);
  }
}

Future<Result<AppointmentRequest>> requestAppointment({
  required ScheduleRepository repository,
  required AppointmentForm form,
}) async {
  final validation = validateAppointmentForm(form);
  if (validation is! Success<AppointmentRequest>) return validation;

  try {
    await repository.createAppointment(validation.data);
    return validation;
  } on SlotUnavailableException {
    return const Failure(slotUnavailableMessage);
  } on Exception catch (error, stackTrace) {
    logError(
      'Failed to request appointment',
      error: error,
      stackTrace: stackTrace,
    );
    return const Failure(appointmentNotSentMessage);
  }
}
