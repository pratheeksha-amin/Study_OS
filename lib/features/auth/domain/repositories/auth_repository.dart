import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<int> signup(UserModel user);

  Future<UserModel?> login(
      String email,
      String password,
      );
}