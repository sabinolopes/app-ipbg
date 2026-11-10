import 'package:app_igreja_guacui/domains/contacts/contacts_repository.dart';
import 'package:app_igreja_guacui/domains/contacts/types.dart';
import 'package:app_igreja_guacui/shared/logger.dart';
import 'package:app_igreja_guacui/shared/result.dart';

const contactsLoadErrorMessage =
    'Não foi possível carregar os contatos. '
    'Verifique sua conexão e tente novamente.';

Future<Result<List<Contact>>> listContacts({
  required ContactsRepository repository,
}) async {
  try {
    final contacts = await repository.list();
    return Success(sortContacts(contacts));
  } on Exception catch (error, stackTrace) {
    logError('Failed to list contacts', error: error, stackTrace: stackTrace);
    return const Failure(contactsLoadErrorMessage);
  }
}
