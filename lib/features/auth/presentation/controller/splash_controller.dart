import 'package:get/get.dart';

import '../../../../../core/network/services/auth_storage_service.dart';
import '../../../../../core/utils/debug_print.dart';
import '../../../category/presentation/controller/category_controller.dart';
import '../../../home/presentation/screens/provider_home_screen.dart';
import '../../../home/presentation/screens/user_home_screen.dart';
import '../../../service/presentation/controller/service_controller.dart';
import '../screens/LogIn_screen.dart';
import '../screens/OnboardingScreen1.dart';
import 'auth_controller.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkAuthenticationStatus();
  }

  Future<void> _checkAuthenticationStatus() async {
    // Add splash delay
    await Future.delayed(const Duration(seconds: 2));

    DPrint.log(
      "\n╔═══════════════════════════════════════════════════════════════",
    );
    DPrint.log("║ 🔄 SPLASH SCREEN - CHECKING AUTHENTICATION STATUS");
    DPrint.log(
      "╚═══════════════════════════════════════════════════════════════\n",
    );

    // Get the service instances
    final authStorageService = Get.find<AuthStorageService>();
    final authController = Get.find<AuthController>();

    // Check if user has a saved refresh token (Remember Me)
    final refreshToken = await authStorageService.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      DPrint.log("❌ No refresh token found - First-time user");
      DPrint.log(
        "═══════════════════════════════════════════════════════════════\n",
      );
      _navigateToOnboarding();
      return;
    }

    DPrint.log("✅ Refresh token found - Validating token...");
    DPrint.log("Calling token refresh API...");

    // Try to refresh the token to validate it and get user data
    final refreshResponse = await authController.refreshToken();

    if (refreshResponse != null) {
      DPrint.log("✅ Token is valid - User is authenticated");
      if (refreshResponse.user != null) {
        DPrint.log("👤 User: ${refreshResponse.user!.name}");
      }
      DPrint.log("🎭 Role: ${refreshResponse.role}");
      DPrint.log(
        "═══════════════════════════════════════════════════════════════\n",
      );

      // Fetch user profile after token validation
      DPrint.log("🔄 Fetching user profile...");
      await authController.fetchUserProfile();
      
      // Fetch categories after token validation
      DPrint.log("🔄 Fetching categories...");
      final categoryController = Get.find<CategoryController>();
      await categoryController.fetchCategories();
      
      // Fetch services after token validation
      DPrint.log("🔄 Fetching services...");
      final serviceController = Get.find<ServiceController>();
      await serviceController.fetchServices();

      // Navigate based on role
      _navigateToHomeBasedOnRole(refreshResponse.role);
    } else {
      DPrint.log("❌ Token validation failed - Redirecting to Login");
      DPrint.log(
        "═══════════════════════════════════════════════════════════════\n",
      );
      _navigateToLogin();
    }
  }

  /// Navigate to home screen based on user role
  void _navigateToHomeBasedOnRole(String role) {
    if (role == 'provider') {
      DPrint.log("🏢 Navigating to Provider Home Screen");
      Get.offAll(
        () => const ProviderHomeScreen(),
        transition: Transition.fade,
      );
    } else if (role == 'user') {
      DPrint.log("👤 Navigating to User Home Screen");
      Get.offAll(
        () => const UserHomeScreen(),
        transition: Transition.fade,
      );
    } else {
      DPrint.log("⚠️ Unknown role: $role - Redirecting to Onboarding");
      _navigateToOnboarding();
    }
  }

  void _navigateToOnboarding() {
    Get.offAll(
      () => const OnboardingScreen1(),
      transition: Transition.fade,
    );
  }

  void _navigateToLogin() {
    Get.offAll(
      () => const LoginScreen(),
      transition: Transition.fade,
    );
  }
}
