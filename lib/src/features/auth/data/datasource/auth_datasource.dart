import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:take_order_app/src/core/data/exception/failure.dart';
import 'package:take_order_app/src/core/data/usecase/usecase.dart';

import '../../business/param/login_params.dart';

class AuthDataSource {
  final _auth = Supabase.instance.client.auth;

  // method to login user
  Future<Either<AuthFailure, AuthResponse>> login(LoginParams params) async {
    try {
      final response = await _auth.signInWithPassword(
          email: params.email, password: params.password);
      print('response');
      print(response);
      if (response.user != null &&
          response.user!.appMetadata['role'] == 'SELLER') {
        return Right(response);
      } else {
        _auth.signOut();
        return Left(AuthFailure(errorMessage: 'Invalid Credential'));
      }
    } on PostgrestException catch (e) {
      print('postgrest error');
      print(e);
      return Left(AuthFailure(errorMessage: 'Invalid Credential'));
    } catch (e) {
      print('error');
      print(e);
      return Left(AuthFailure(errorMessage: 'Invalid Credential'));
    }
  }

  // method to logout user
  Future<Either<AuthFailure, String>> logout(NoParams param) async {
    try {
      await _auth.signOut();
      return const Right('Logged out');
    } catch (e) {
      return Left(AuthFailure(errorMessage: 'Error logging out'));
    }
  }

  // method to check if user is logged in
  bool isLoggedIn(NoParams param) {
    print('is logged in');
    print(_auth.currentUser);
    print('-' * 100);
    return _auth.currentUser != null;
  }

  // method to get user
  User? getUser(NoParams param) {
    return _auth.currentUser;
  }

  Stream<AuthState> onAuthStateChange() {
    return _auth.onAuthStateChange;
  }
}
