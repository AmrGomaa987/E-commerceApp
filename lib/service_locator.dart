import 'package:ecommerce_app_with_flutter/data/auth/repository/auth_repository_impl.dart';
import 'package:ecommerce_app_with_flutter/data/auth/source/auth_firebase_service.dart';
import 'package:ecommerce_app_with_flutter/data/category/repository/category.dart';
import 'package:ecommerce_app_with_flutter/data/category/source/category_firebase_service.dart';
import 'package:ecommerce_app_with_flutter/data/order/repository/order.dart';
import 'package:ecommerce_app_with_flutter/data/order/source/order_firebase_service.dart';
import 'package:ecommerce_app_with_flutter/data/payment/repository/payment_repository_impl.dart';
import 'package:ecommerce_app_with_flutter/data/payment/source/paymob_service.dart';
import 'package:ecommerce_app_with_flutter/data/product/repository/product.dart';
import 'package:ecommerce_app_with_flutter/data/product/source/product_firebase_service.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/repository/auth.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/get_ages.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/get_user.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/is_logged_in.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/logout.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/send_password_reset_email.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/signin.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/signup.dart';
import 'package:ecommerce_app_with_flutter/domain/category/repository/category.dart';
import 'package:ecommerce_app_with_flutter/domain/category/usecases/get_categories.dart';
import 'package:ecommerce_app_with_flutter/domain/order/repository/order.dart';
import 'package:ecommerce_app_with_flutter/domain/order/usecases/add_to_cart.dart';
import 'package:ecommerce_app_with_flutter/domain/order/usecases/get_cart_products.dart';
import 'package:ecommerce_app_with_flutter/domain/order/usecases/get_orders.dart';
import 'package:ecommerce_app_with_flutter/domain/order/usecases/order_registration.dart';
import 'package:ecommerce_app_with_flutter/domain/order/usecases/remove_cart_product.dart';
import 'package:ecommerce_app_with_flutter/domain/order/usecases/update_cart_quantity.dart';
import 'package:ecommerce_app_with_flutter/domain/payment/repository/payment_repository.dart';
import 'package:ecommerce_app_with_flutter/domain/payment/usecases/process_payment.dart';
import 'package:ecommerce_app_with_flutter/domain/product/repository/product.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/add_or_remove_favorite_product.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/get_favorties_products.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/get_new_in.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/get_products_by_category_id.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/get_products_by_title.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/get_top_selling.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/is_favorite.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> initializeDependancies() async {
  //services
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<CategoryFirebaseService>(CategoryFirebaseServiceImpl());
  sl.registerSingleton<ProductFirebaseService>(ProductFirebaseServiceImpl());
  sl.registerSingleton<OrderFirebaseService>(OrderFirebaseServiceImpl());
  sl.registerSingleton<PayMobService>(PayMobServiceImpl());
  //repositry
  sl.registerSingleton<AuthRepositry>(AuthRepositoryImpl());
  sl.registerSingleton<CategoryRepository>(CategoryRepositoryImpl());
  sl.registerSingleton<ProductRepository>(ProductRepositoryImpl());
  sl.registerSingleton<OrderRepository>(OrderRepositoryImpl());
  sl.registerSingleton<PaymentRepository>(PaymentRepositoryImpl());
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
  sl.registerSingleton<GetTopSellingUseCase>(GetTopSellingUseCase());
  sl.registerSingleton<GetNewInUseCase>(GetNewInUseCase());
  sl.registerSingleton<GetProductsByCategoryIdUseCase>(
    GetProductsByCategoryIdUseCase(),
  );
  sl.registerSingleton<GetProductsByTitleUseCase>(GetProductsByTitleUseCase());
  sl.registerSingleton<AddToCartUseCase>(AddToCartUseCase());
  sl.registerSingleton<GetCartProductsUseCase>(GetCartProductsUseCase());
  sl.registerSingleton<RemoveCartProductUseCase>(RemoveCartProductUseCase());
  sl.registerSingleton<UpdateCartQuantityUseCase>(UpdateCartQuantityUseCase());
  sl.registerSingleton<OrderRegistrationUseCase>(OrderRegistrationUseCase());
  sl.registerSingleton<AddOrRemoveFavoriteProductUseCase>(
    AddOrRemoveFavoriteProductUseCase(),
  );
  sl.registerSingleton<IsFavoriteUseCase>(IsFavoriteUseCase());
  sl.registerSingleton<GetFavortiesProductsUseCase>(
    GetFavortiesProductsUseCase(),
  );
  sl.registerSingleton<GetOrdersUseCase>(GetOrdersUseCase());
  sl.registerSingleton<ProcessPaymentUseCase>(ProcessPaymentUseCase());
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());
}
