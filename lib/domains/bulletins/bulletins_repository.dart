import 'package:app_igreja_guacui/domains/bulletins/types.dart';

abstract interface class BulletinsRepository {
  Future<List<Bulletin>> list();
}
