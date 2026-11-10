import 'package:app_igreja_guacui/domains/bulletins/bulletins_repository.dart';
import 'package:app_igreja_guacui/domains/bulletins/types.dart';
import 'package:app_igreja_guacui/shared/logger.dart';
import 'package:app_igreja_guacui/shared/result.dart';

const bulletinsLoadErrorMessage =
    'Não foi possível carregar os boletins. '
    'Verifique sua conexão e tente novamente.';

Future<Result<List<Bulletin>>> listBulletins({
  required BulletinsRepository repository,
}) async {
  try {
    final bulletins = await repository.list();
    return Success(sortBulletins(bulletins));
  } on Exception catch (error, stackTrace) {
    logError('Failed to list bulletins', error: error, stackTrace: stackTrace);
    return const Failure(bulletinsLoadErrorMessage);
  }
}
