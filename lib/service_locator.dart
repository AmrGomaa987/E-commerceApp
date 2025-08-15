import 'package:ecommerce_app_with_flutter/data/auth/repository/auth_repository_impl.dart';
import 'package:ecommerce_app_with_flutter/data/auth/source/auth_firebase_service.dart';
import 'package:ecommerce_app_with_flutter/data/category/repository/category.dart';
import 'package:ecommerce_app_with_flutter/data/category/source/category_firebase_service.dart';
import 'package:ecommerce_app_with_flutter/data/product/repository/product.dart';
import 'package:ecommerce_app_with_flutter/data/product/source/product_firebase_service.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/repository/auth.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/get_ages.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/get_user.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/is_logged_in.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/send_password_reset_email.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/signin.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/signup.dart';
import 'package:ecommerce_app_with_flutter/domain/category/repository/category.dart';
import 'package:ecommerce_app_with_flutter/domain/category/usecases/get_categories.dart';
import 'package:ecommerce_app_with_flutter/domain/product/repository/product.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/get_top_selling.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> initializeDependancies() async {
  //services
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<CategoryFirebaseService>(CategoryFirebaseServiceImpl());
     sl.registerSingleton<ProductFirebaseService>(
    ProductFirebaseServiceImpl()
  );
  //repositry
  sl.registerSingleton<AuthRepositry>(AuthRepositoryImpl());
  sl.registerSingleton<CategoryRepository>(CategoryRepositoryImpl());
    sl.registerSingleton<ProductRepository>(
    ProductRepositoryImpl()
  );
  //usecase
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<GetAgesUseCase>(GetAgesUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<SendpasswordResetEmailUseCase>(
    SendpasswordResetEmailUseCase(),
  );
  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  sl.registerSingleton<GetCategoriesUseCase>(GetCategoriesUseCase());
    sl.registerSingleton<GetTopSellingUseCase>(
    GetTopSellingUseCase()
  );
}
