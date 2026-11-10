import 'package:app_igreja_guacui/domains/bulletins/bulletins_repository.dart';
import 'package:app_igreja_guacui/domains/bulletins/types.dart';

class InMemoryBulletinsRepository implements BulletinsRepository {
  InMemoryBulletinsRepository(this.bulletins);

  final List<Bulletin> bulletins;
  bool isOffline = false;

  @override
  Future<List<Bulletin>> list() async {
    if (isOffline) throw Exception('no connection');

    return [...bulletins];
  }
}
