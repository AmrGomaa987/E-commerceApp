import 'package:ecommerce_app_with_flutter/domain/auth/usecases/is_logged_in.dart';
import 'package:ecommerce_app_with_flutter/presentation/splash/bloc/splach_state.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplachState> {
  SplashCubit() : super(DisplaySplash());
  void appStarted() async {
    await Future.delayed(Duration(seconds: 2));
    var isLoggedIn = await sl<IsLoggedInUseCase>().call();
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }
}
