import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource =
  AuthLocalDataSource();

  @override
  Future<int> signup(UserModel user) {
    return localDataSource.signup(user);
  }

  @override
  Future<UserModel?> login(
      String email,
      String password,
      ) {
    return localDataSource.login(
      email,
      password,
    );
  }
}