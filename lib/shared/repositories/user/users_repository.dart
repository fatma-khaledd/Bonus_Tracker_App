import '../../models/models.dart';

abstract class UsersRepository {
  Future<UserModel?> getUser(String uid);
}
