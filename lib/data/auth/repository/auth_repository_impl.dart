import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/data/auth/models/user.dart';
import 'package:ecommerce_app_with_flutter/data/auth/models/user_creation_req.dart';
import 'package:ecommerce_app_with_flutter/data/auth/models/user_signin_req.dart';
import 'package:ecommerce_app_with_flutter/data/auth/source/auth_firebase_service.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/repository/auth.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';

class AuthRepositoryImpl extends AuthRepositry {
  @override
  Future<Either> signup(UserCreationReq user) async {
    return await sl<AuthFirebaseService>().signup(user);
  }

  @override
  Future<Either> getAges() async {
    return await sl<AuthFirebaseService>().getAges();
  }

  @override
  Future<Either> signin(UserSigninReq user) async {
    return await sl<AuthFirebaseService>().signin(user);
  }

  @override
  Future<Either> sendPasswordResetEmail(String email) async {
    return await sl<AuthFirebaseService>().sendPasswordResetEmail(email);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthFirebaseService>().isLoggedIn();
  }

  @override
  Future<Either> getUser() async {
    var user = await sl<AuthFirebaseService>().getUser();
    return user.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(UserModel.fromMap(data).toEntity());
      },
    );
  }

  @override
  Future<Either> logout() async {
    return await sl<AuthFirebaseService>().logout();
  }
}
