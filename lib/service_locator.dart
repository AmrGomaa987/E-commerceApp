import 'package:ecommerce_app_with_flutter/data/auth/repository/auth_repository_impl.dart';
import 'package:ecommerce_app_with_flutter/data/auth/source/auth_firebase_service.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/repository/auth.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/get_ages.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/get_user.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/is_logged_in.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/send_password_reset_email.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/signin.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/signup.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> initializeDependancies() async {
  //services
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  //repositry
  sl.registerSingleton<AuthRepositry>(AuthRepositoryImpl());
  //usecase
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<GetAgesUseCase>(GetAgesUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<SendpasswordResetEmailUseCase>(SendpasswordResetEmailUseCase());
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
}
