import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/base/base_controller.dart';
import '../../../../../core/network/services/auth_storage_service.dart';
import '../../../../../core/services/sound_service.dart';
import '../../../../../core/utils/debug_print.dart';
import '../../data/model/forgot_pass_request_model.dart';
import '../../data/model/login_request_model.dart';
import '../../data/model/refresh_token_request_model.dart';
import '../../data/model/refresh_token_response_model.dart';
import '../../data/model/register_request_model.dart';
import '../../data/model/set_password_request_model.dart';
import '../../data/model/verify_otp_request-model.dart';
import '../../domain/repo/auth_repo.dart';
import '../screens/LogIn_screen.dart';
import '../screens/Otp_verify_screen.dart' as ForgotPasswordOtp;
import '../screens/auth_decision_screen.dart';
import '../screens/set_new_password_screen.dart';
import '../widgets/otp_verification_popup.dart';


class AuthController extends BaseController {
  final AuthRepository _authRepository;
  final AuthStorageService _authStorageService;

  AuthController(this._authRepository, this._authStorageService);

  Future<void> login(String email, String password) async {
    setLoading(true);
    setError("");

    DPrint.log(
      "\n╔═══════════════════════════════════════════════════════════════",
    );
    DPrint.log("║ 🔐 LOGIN ATTEMPT");
    DPrint.log(
      "╠═══════════════════════════════════════════════════════════════",
    );
    DPrint.log("║ 📧 Email: $email");
    DPrint.log("║ 🔑 Password: ${password.replaceAll(RegExp(r'.'), '*')}");
    DPrint.log(
      "╚═══════════════════════════════════════════════════════════════\n",
    );

    final request = LoginRequestModel(email: email, password: password);

    final result = await _authRepository.login(request);

    result.fold(
      (fail) {
        debugPrint("❌ API Error: ${fail.message}");
        setError(fail.message);

        // Show Snackbar on failure
        Get.snackbar(
          "Login Failed",
          fail.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        setLoading(false);
      },
      (success) async {
        debugPrint("✅ API Hit Successful!");

        // Store auth data for all roles
        await _authStorageService.storeAuthData(
          accessToken: success.data.accessToken,
          refreshToken: success.data.refreshToken,
          userId: success.data.user.id,
        );
        
        // Store role separately
        await _authStorageService.storeSelectedRole(success.data.role);

        // Optional: show success Snackbar
        Get.snackbar(
          "Success",
          "Logged in successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );

        setLoading(false);

        // Check if player has incomplete profile (empty sportPreferences)
        // NOTE: This field no longer exists in the new model
        // final isPlayerWithIncompleteProfile =
        //     success.data.role == 'player' &&
        //     (success.data.user.sportPreferences.isEmpty);

        // Check if instructor has incomplete profile (empty gender field)
        // NOTE: This field no longer exists in the new model
        // final isInstructorWithIncompleteProfile =
        //     success.data.role == 'instructor' &&
        //     (success.data.user.gender == null ||
        //         success.data.user.gender!.isEmpty);
      },
    );
  }

  Future<void> register(
    String email,
    String password,
    String confirmPassword,
    String role,
  ) async {
    setLoading(true);
    setError('');

    // Map frontend role to API role
    // beardfriend -> user, barbershop -> provider
    String apiRole = role == 'beardfriend' ? 'user' : 'provider';

    DPrint.log(
      "\n╔═══════════════════════════════════════════════════════════════",
    );
    DPrint.log("║ 📝 REGISTER ATTEMPT");
    DPrint.log(
      "╠═══════════════════════════════════════════════════════════════",
    );
    DPrint.log("║ 📧 Email: $email");
    DPrint.log("║ 🎭 Frontend Role: $role");
    DPrint.log("║ 🎭 API Role: $apiRole");
    DPrint.log(
      "╚═══════════════════════════════════════════════════════════════\n",
    );

    // Local validation first
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all required fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      setLoading(false);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        "Error",
        "Password and Confirm Password do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      setLoading(false);
      return;
    }

    final request = RegisterRequestModel(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      role: apiRole,
    );

    final result = await _authRepository.register(request);

    result.fold(
      (fail) {
        setError(fail.message);

        // Show Snackbar for API error
        Get.snackbar(
          "Error",
          fail.message.contains("email")
              ? "Email already exists"
              : fail.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        DPrint.log("Register failed: ${fail.message}");
        setLoading(false);
      },
      (success) async {
        DPrint.log("✅ Register success: ${success.data.user.email}");

        // Store auth data (same as login)
        await _authStorageService.storeAuthData(
          accessToken: success.data.accessToken,
          refreshToken: success.data.refreshToken,
          userId: success.data.user.id,
        );
        
        // Store role separately
        await _authStorageService.storeSelectedRole(success.data.role);

        // Initialize ProviderController if role is provider
        // Use permanent: true to keep it in memory across navigation

        setLoading(false);
      },
    );
  }

  Future forgotPassword(String email) async {
    setLoading(true);
    setError('');

    DPrint.log(
      "\n╔═══════════════════════════════════════════════════════════════",
    );
    DPrint.log("║ 🔑 FORGOT PASSWORD REQUEST");
    DPrint.log(
      "╠═══════════════════════════════════════════════════════════════",
    );
    DPrint.log("║ 📧 Email: $email");
    DPrint.log(
      "╚═══════════════════════════════════════════════════════════════\n",
    );

    // Validate email
    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      setLoading(false);
      return;
    }

    final request = ForgotPassRequestModel.fromJson({'email': email});
    final result = await _authRepository.forgotPassword(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("❌ Forgot password failed: ${fail.message}");

        Get.snackbar(
          "Error",
          fail.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        setLoading(false);
      },
      (success) {
        DPrint.log("✅ OTP sent successfully: ${success.message}");

        Get.snackbar(
          "Success",
          "OTP sent to your email",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );

        setLoading(false);
        Get.to(() => ForgotPasswordOtp.OtpVerificationScreen(email: email));
      },
    );
  }

  /// Verify OTP for both registration and forgot password flows
  /// [isRegistrationFlow] - true for registration, false for forgot password
  Future verifyOTP(
    String email,
    String otp, {
    bool isRegistrationFlow = false,
  }) async {
    setLoading(true);
    setError("");

    DPrint.log(
      "\n╔═══════════════════════════════════════════════════════════════",
    );
    DPrint.log("║ 🔢 OTP VERIFICATION ATTEMPT");
    DPrint.log(
      "╠═══════════════════════════════════════════════════════════════",
    );
    DPrint.log("║ 📧 Email: $email");
    DPrint.log("║ 🔑 OTP: ${otp.replaceAll(RegExp(r'.'), '*')}");
    DPrint.log(
      "║ 📱 Flow: ${isRegistrationFlow ? 'Registration' : 'Forgot Password'}",
    );
    DPrint.log(
      "╚═══════════════════════════════════════════════════════════════\n",
    );

    // Validate inputs
    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Email is missing",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      setLoading(false);
      return;
    }

    if (otp.isEmpty || otp.length < 4) {
      Get.snackbar(
        "Error",
        "Please enter a valid OTP",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      setLoading(false);
      return;
    }

    final request = VerifyMailOtpRequest(email: email, otp: otp);
    final result = await _authRepository.verifyOtp(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("❌ OTP verification failed: ${fail.message}");

        setLoading(false);

        // Show failure popup
        if (Get.context != null) {
          showOtpVerificationPopup(
            context: Get.context!,
            isSuccess: false,
            message: "Account not Verified!",
            displayDuration: const Duration(seconds: 3),
          );
        } else {
          Get.snackbar(
            "Error",
            fail.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            duration: const Duration(seconds: 3),
          );
        }
      },
      (success) {
        DPrint.log("✅ OTP verified successfully: ${success.message}");

        setLoading(false);
      },
    );
  }

  Future setNewPass(
    String email,
    String otp,
    String newPassword,
    String confirmPassword,
  ) async {
    setLoading(true);
    setError("");

    // Validate passwords
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter passwords",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      setLoading(false);
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
      setLoading(false);
      return;
    }

    final request = ResetPasswordRequestModel(
      email: email,
      otp: otp,
      password: newPassword,
      confirmPassword: confirmPassword,
    );
    final result = await _authRepository.setNewPassword(request);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log("❌ Set new password failed: ${fail.message}");

        Get.snackbar(
          "Error",
          fail.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
        );

        setLoading(false);
      },
      (success) {
        DPrint.log("✅ Password set successfully: ${success.message}");

        setLoading(false);

        // Show success popup then navigate to login
        if (Get.context != null) {
          showOtpVerificationPopup(
            context: Get.context!,
            isSuccess: true,
            message: "Verified successfully.",
            displayDuration: const Duration(seconds: 3),
            onDismiss: () {
              // Navigate to login screen after popup dismisses
              Get.offAll(
                () => const LoginRoleScreen(),
                transition: Transition.leftToRight,
              );
            },
          );
        } else {
          Get.offAll(
            () => const LoginRoleScreen(),
            transition: Transition.leftToRight,
          );
        }
      },
    );
  }

  Future<RefreshTokenResponseModel?> refreshToken() async {
    // setLoading(true); // Don't show loading on splash

    final refreshToken = await _authStorageService.getRefreshToken();
    DPrint.log("🐞 DEBUG: Got refresh token: $refreshToken");

    if (refreshToken == null || refreshToken.isEmpty) {
      DPrint.log("❌ No refresh token stored");
      setLoading(false);
      return null; // Return null instead of false
    }

    final request = RefreshTokenRequestModel(refreshToken: refreshToken);
    final result = await _authRepository.refreshToken(request);

    return result.fold(
      (fail) async {
        DPrint.log("❌ Refresh token failed: ${fail.message}");
        await _authStorageService.clearAuthData(); // clear invalid token
        setLoading(false);
        return null; // Return null on failure
      },
      (success) async {
        DPrint.log("✅ Refresh token success: ${success.message}");
        
        // Store the new tokens
        await _authStorageService.storeAuthData(
          accessToken: success.data.accessToken,
          refreshToken: success.data.refreshToken,
          userId: success.data.user.id,
        );
        
        // Store role
        await _authStorageService.storeSelectedRole(success.data.role);
        
        setLoading(false);
        return success.data; // Return the full response data
      },
    );
  }

  Future<void> logout() async {
    try {
      setLoading(true);
      
      // Call logout API
      final result = await _authRepository.logout();
      
      result.fold(
        (failure) {
          // Even if API fails, clear local data and redirect
          DPrint.log("⚠️ Logout API failed: ${failure.message}");
          _clearLocalDataAndNavigate();
        },
        (success) {
          DPrint.log("✅ Logout successful");
          _clearLocalDataAndNavigate();
        },
      );
    } catch (e) {
      // Even on exception, clear local data
      DPrint.log("❌ Logout error: $e");
      _clearLocalDataAndNavigate();
    }
  }

  /// Helper method to clear local data and navigate to auth decision screen
  Future<void> _clearLocalDataAndNavigate() async {
    await _authStorageService.clearAuthData();
    setLoading(false);


    // Show success snackbar
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
    );
    
    // Navigate to auth decision screen (user can choose Log In or Sign Up)
    Get.offAll(() => const AuthDecisionScreen());
  }
}
