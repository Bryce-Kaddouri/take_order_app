import 'package:dartz/dartz.dart';
import 'package:gotrue/src/types/auth_response.dart';
import 'package:gotrue/src/types/auth_state.dart';
import 'package:gotrue/src/types/user.dart';
import 'package:take_order_app/src/core/data/exception/failure.dart';
import 'package:take_order_app/src/core/data/usecase/usecase.dart';

import '../../business/param/login_params.dart';
import '../../business/repository/auth_repository.dart';
import '../datasource/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<AuthFailure, bool>> login(LoginParams params) async {
    return await dataSource.login(params);
  }

  @override
  User? getUser(NoParams param) {
    return dataSource.getUser(param);
  }

  @override
  bool isLoggedIn(NoParams param) {
    return dataSource.isLoggedIn(param);
  }

  @override
  Future<Either<AuthFailure, String>> logout(NoParams param) async {
    return await dataSource.logout(param);
  }

  @override
  Stream<AuthState> onAuthStateChange(NoParams param) {
    return dataSource.onAuthStateChange();
  }
}
