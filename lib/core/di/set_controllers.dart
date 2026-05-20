import 'package:get/get.dart';

import '../../features/auth/presentation/controller/auth_controller.dart';
import '../../features/auth/presentation/controller/splash_controller.dart';
import '../../features/auth/presentation/controller/user_controller.dart';
import '../../features/category/domain/repo/category_repo.dart';
import '../../features/category/presentation/controller/category_controller.dart';
import '../../features/service/domain/repo/service_repo.dart';
import '../../features/service/presentation/controller/service_controller.dart';


void setupController() {
  Get.put<AuthController>(
    AuthController(Get.find(), Get.find()),
    permanent: true,
  );

  Get.put<UserController>(
    UserController(),
    permanent: true,
  );

  Get.put<SplashScreenController>(
    SplashScreenController(),
    permanent: true,
  );

  Get.put<CategoryController>(
    CategoryController(categoryRepository: Get.find<CategoryRepository>()),
    permanent: true,
  );

  Get.put<ServiceController>(
    ServiceController(serviceRepository: Get.find<ServiceRepository>()),
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
