import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/data/auth/models/user_creation_req.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_signin_req.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(UserCreationReq user);
  Future<Either> signin(UserSigninReq user);
  Future<Either> getAges();
  Future<Either> sendPasswordResetEmail(String email);
  Future<bool> isLoggedIn();
  Future<Either> getUser();
  Future<Either> logout();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signup(UserCreationReq user) async {
    try {
      // Validate required fields
      if (user.email == null || user.email!.isEmpty) {
        return Left('Email is required');
      }
      if (user.password == null || user.password!.isEmpty) {
        return Left('Password is required');
      }
      if (user.firstName == null || user.firstName!.isEmpty) {
        return Left('First name is required');
      }
      if (user.lastName == null || user.lastName!.isEmpty) {
        return Left('Last name is required');
      }

      var returnedData = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email!,
            password: user.password!,
          );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(returnedData.user!.uid)
          .set({
            'firstName': user.firstName,
            'lastName': user.lastName,
            'email': user.email,
            'gender': user.gender,
            'age': user.age,
          });
      return Right('sign up was successful');
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak';
          break;
        case 'email-already-in-use':
          message = 'An account already exists with that email';
          break;
        case 'invalid-email':
          message = 'Invalid email address format';
          break;
        case 'operation-not-allowed':
          message = 'Email/password accounts are not enabled';
          break;
        case 'network-request-failed':
          message = 'Network error. Please check your connection';
          break;
        case 'too-many-requests':
          message = 'Too many requests. Please try again later';
          break;
        default:
          message = 'An error occurred during signup: ${e.message}';
      }
      return Left(message);
    } catch (e) {
      return Left('An unexpected error occurred. Please try again');
    }
  }

  @override
  Future<Either> getAges() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection('Ages')
          .get();
      return Right(returnedData.docs);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> signin(UserSigninReq user) async {
    try {
      // Validate required fields
      if (user.email == null || user.email!.isEmpty) {
        return Left('Email is required');
      }
      if (user.password == null || user.password!.isEmpty) {
        return Left('Password is required');
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      return Right('sign in was successful');
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'invalid-email':
          message = 'Invalid email address format';
          break;
        case 'invalid-credential':
          message = 'Invalid email or password';
          break;
        case 'user-not-found':
          message = 'No user found for that email';
          break;
        case 'wrong-password':
          message = 'Wrong password provided';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled';
          break;
        case 'too-many-requests':
          message = 'Too many requests. Please try again later';
          break;
        case 'network-request-failed':
          message = 'Network error. Please check your connection';
          break;
        default:
          message = 'An error occurred during signin: ${e.message}';
      }
      return Left(message);
    } catch (e) {
      return Left('An unexpected error occurred. Please try again');
    }
  }

  @override
  Future<Either> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return Right('password reset email is sent');
    } catch (e) {
      return Left('plz try again');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Either> getUser() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      var userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser?.uid)
          .get()
          .then((value) => value.data());
      return Right(userData);
    } catch (e) {
      return Left('plz try again');
    }
  }

  @override
  Future<Either> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return Right('Logged out successfully');
    } catch (e) {
      return Left('Failed to logout. Please try again');
    }
  }
}
