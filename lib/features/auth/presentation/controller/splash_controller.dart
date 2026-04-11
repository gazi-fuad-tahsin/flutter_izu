import 'package:get/get.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/services/auth_storage_service.dart';
import '../../../../../core/services/socket_service.dart';
import '../../../../../core/utils/debug_print.dart';
import '../screens/auth_decision_screen.dart';
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
      _navigateToRoleSelection();
      return;
    }

    DPrint.log("✅ Refresh token found - Validating token...");
    DPrint.log("Calling token refresh API...");

    // Try to refresh the token to validate it and get user data
    final refreshResponse = await authController.refreshToken();

    if (refreshResponse != null) {
      DPrint.log("✅ Token is valid - User is authenticated");
      DPrint.log("👤 User: ${refreshResponse.user.name}");
      DPrint.log("🎭 Role: ${refreshResponse.role}");
      DPrint.log(
        "═══════════════════════════════════════════════════════════════\n",
      );

    //   if (refreshResponse.role == 'provider') {
    //     // Provider: fetchProfileAndNavigate stores userId then connects socket
    //     if (!Get.isRegistered<ProviderController>()) {
    //       Get.put(ProviderController(), permanent: true);
    //     }
    //     final providerController = Get.find<ProviderController>();
    //     await providerController.fetchProfileAndNavigate();
    //   } else {
    //     // User / other roles: fetch profile first to get & store userId,
    //     // then connect socket, then navigate to MainScreen.
    //     await _fetchProfileStoreUserIdAndNavigate(authStorageService);
    //   }
    // } else {
    //   DPrint.log("❌ Token validation failed - Redirecting to Role Selection");
    //   DPrint.log(
    //     "═══════════════════════════════════════════════════════════════\n",
    //   );
    //   _navigateToRoleSelection();
    }
  }

  /// Calls GET /user/profile, stores the returned userId, connects the socket,
  /// and then navigates to [MainScreen].
  /// Falls back to [MainScreen] even if the profile call fails.
  // Future<void> _fetchProfileStoreUserIdAndNavigate(
  //   AuthStorageService authStorageService,
  // ) async {
  //   try {
  //     final providerRepository = ProviderRepository(Get.find<ApiClient>());
  //     final result = await providerRepository.getUserProfile();

  //     result.fold(
  //       (failure) {
  //         DPrint.log(
  //           '⚠️ Could not fetch user profile during auto-login (non-fatal): ${failure.message}',
  //         );
  //       },
  //       (success) async {
  //         final UserProfileResponse profile = success.data;

  //         // Store the real userId from the profile response
  //         if (profile.id.isNotEmpty) {
  //           await authStorageService.storeUserId(profile.id);
  //           DPrint.log('💾 Stored userId from profile: ${profile.id}');
  //         }

  //         // Connect socket now that userId is in secure storage
  //         try {
  //           final socketService = Get.find<SocketService>();
  //           await socketService.connect();
  //           DPrint.log('🔌 Socket connected for user (userId: ${profile.id})');
  //         } catch (e) {
  //           DPrint.log('⚠️ Socket connect error (non-fatal): $e');
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     DPrint.log('⚠️ _fetchProfileStoreUserIdAndNavigate exception (non-fatal): $e');
  //   }

  //   // Always navigate to MainScreen regardless of profile fetch outcome
  //   _navigateToHome();
  // }

  // void _navigateToHome() {
  //   Get.offAll(
  //     () => const MainScreen(),
  //     transition: Transition.fade,
  //   );
  // }

  void _navigateToRoleSelection() {
    Get.offAll(
      () => const AuthDecisionScreen(),
      transition: Transition.fade,
    );
  }
}
