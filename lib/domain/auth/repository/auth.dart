import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/data/auth/models/user_creation_req.dart';

import '../../../data/auth/models/user_signin_req.dart';

abstract class AuthRepositry {
  Future<Either> signup(UserCreationReq user);
  Future<Either> signin(UserSigninReq user);
  Future<Either> getAges();
  Future<Either> sendPasswordResetEmail(String email);
  Future<bool> isLoggedIn();
}
