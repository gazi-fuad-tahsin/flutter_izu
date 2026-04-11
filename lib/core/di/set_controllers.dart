import 'package:get/get.dart';

import '../../features/auth/presentation/controller/auth_controller.dart';
import '../../features/auth/presentation/controller/splash_controller.dart';


void setupController() {
  Get.put<AuthController>(
    AuthController(Get.find(), Get.find()),
    permanent: true,
  );

  Get.put<SplashScreenController>(
    SplashScreenController(),
    permanent: true,
  );

  // Get.lazyPut<SignInController>(
  //   () => SignInController(),
  //   fenix: true
  // );
  //
  // Get.lazyPut<SignUpController>(
  //     () => SignUpController(),
  //   fenix: true
  // );
  //
  // Get.lazyPut<OtpVerifyController>(
  //     () => OtpVerifyController(),
  //   fenix: true
  // );
  //
  // Get.lazyPut<NewPasswordController>(
  //     () => NewPasswordController(),
  //   fenix: true
  // );

}
