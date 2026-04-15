import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/base/base_controller.dart';
import '../../../../../core/network/services/auth_storage_service.dart';
import '../../../../../core/network/services/socket_service.dart';
import '../../../../../core/utils/debug_print.dart';
import '../../../category/presentation/controller/category_controller.dart';
import '../../../home/presentation/screens/provider_home_screen.dart';
import '../../../home/presentation/screens/user_home_screen.dart';
import '../../../service/presentation/controller/service_controller.dart';
import '../../data/model/forgot_pass_request_model.dart';
import '../../data/model/login_request_model.dart';
import '../../data/model/refresh_token_request_model.dart';
import '../../data/model/refresh_token_response_model.dart';
import '../../data/model/register_request_model.dart';
import '../../data/model/set_password_request_model.dart';
import '../../data/model/signup_request_model.dart';
import '../../data/model/verify_otp_request-model.dart';
import '../../domain/repo/auth_repo.dart';
import '../screens/LogIn_screen.dart';
import '../screens/otp_verification_screen.dart';
import '../screens/selfie_verification_screen.dart';
import '../screens/set_new_password_screen.dart';
import 'user_controller.dart';


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

        // Show success Snackbar
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

        // Fetch user profile after successful login
        await fetchUserProfile();
        
        // Fetch categories after successful login
        final categoryController = Get.find<CategoryController>();
        await categoryController.fetchCategories();
        
        // Fetch services after successful login
        final serviceController = Get.find<ServiceController>();
        await serviceController.fetchServices();

        // Connect to socket after successful login
        DPrint.log("🔌 Connecting to Socket Server...");
        await _connectSocketAfterLogin(success.data.user.id, success.data.accessToken);

        // Navigate based on role
        if (success.data.role == 'provider') {
          // Navigate to Provider Home Screen
          Get.offAll(() => const ProviderHomeScreen());
        } else {
          // Navigate to User Home Screen
          Get.offAll(() => const UserHomeScreen());
        }
      },
    );
  }

  Future<void> fetchUserProfile() async {
    DPrint.log("🔄 Fetching user profile...");
    
    final result = await _authRepository.fetchUserProfile();
    
    result.fold(
      (fail) {
        DPrint.log("❌ Failed to fetch user profile: ${fail.message}");
      },
      (success) {
        DPrint.log("✅ User profile fetched successfully!");
        // Store profile in UserController
        final userController = Get.find<UserController>();
        userController.setUserProfile(success.data);
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

  Future<void> signup(
    String name,
    String email,
    String password,
    String accountType,
    String phone,
  ) async {
    setLoading(true);
    setError('');

    DPrint.log(
      "\n╔═══════════════════════════════════════════════════════════════",
    );
    DPrint.log("║ 📝 SIGNUP ATTEMPT");
    DPrint.log(
      "╠═══════════════════════════════════════════════════════════════",
    );
    DPrint.log("║ 👤 Name: $name");
    DPrint.log("║ 📧 Email: $email");
    DPrint.log("║ 🎭 Account Type: $accountType");
    DPrint.log("║ 📞 Phone: $phone");
    DPrint.log(
      "╚═══════════════════════════════════════════════════════════════\n",
    );

    // Validation
    if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
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

    if (password.length < 6) {
      Get.snackbar(
        "Error",
        "Password must be at least 6 characters",
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

    final request = SignupRequestModel(
      name: name,
      email: email,
      password: password,
      accountType: accountType,
      phone: phone,
    );

    final result = await _authRepository.signup(request);

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

        DPrint.log("Signup failed: ${fail.message}");
        setLoading(false);
      },
      (success) async {
        DPrint.log("✅ Signup success: ${success.data.email}");

        // Show success Snackbar
        Get.snackbar(
          "Success",
          "Account created successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );

        setLoading(false);

        // Navigate to selfie verification screen
        Get.off(() => const SelfieVerificationScreen());
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
        DPrint.log("✅ OTP sent successfully");
        DPrint.log("📧 Email: ${success.data.email}");
        DPrint.log("⏰ OTP Expiry: ${success.data.otpExpiry}");

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
        Get.to(() => OtpVerificationScreen(email: email));
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

        // Show failure snackbar
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
      },
      (success) {
        DPrint.log("✅ OTP verified successfully");
        DPrint.log("📧 Email: ${success.data.email}");

        setLoading(false);
        // Navigate to set new password screen with email and otp
        Get.to(() => SetNewPasswordScreen(email: email, otp: otp));
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
        DPrint.log("✅ Password set successfully");
        DPrint.log("📧 Email: ${success.data.email}");

        setLoading(false);

        // Show snackbar with success message
        Get.snackbar(
          "Success",
          "Password reset successfully. Please login with your new password.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 2),
        );

        // Navigate to login screen
        Get.offAll(
          () => const LoginScreen(),
          transition: Transition.leftToRight,
        );
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

    // Handle fold synchronously and return the result directly
    bool isSuccess = false;
    RefreshTokenResponseModel? responseData;

    result.fold(
      (fail) {
        DPrint.log("❌ Refresh token failed: ${fail.message}");
        isSuccess = false;
      },
      (success) {
        DPrint.log("✅ Refresh token success: ${success.message}");
        isSuccess = true;
        responseData = success.data;
      },
    );

    // Handle async operations and return
    if (isSuccess && responseData != null) {
      try {
        // Get existing data from storage (in case they're not in response)
        final existingUserId = await _authStorageService.getUserId();
        final existingRefreshToken = await _authStorageService.getRefreshToken();

        // Use new tokens from API, or fall back to existing ones if not provided
        final newAccessToken = responseData!.accessToken.isNotEmpty 
          ? responseData!.accessToken 
          : await _authStorageService.getAccessToken() ?? '';
        
        final newRefreshToken = responseData!.refreshToken.isNotEmpty 
          ? responseData!.refreshToken 
          : existingRefreshToken ?? ''; // Keep old refresh token if API doesn't return new one

        DPrint.log("🔑 Access Token: ${newAccessToken.substring(0, 20)}...");
        DPrint.log("🔄 Refresh Token: ${newRefreshToken.substring(0, 20)}...");

        // Store the tokens
        await _authStorageService.storeAuthData(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
          userId: responseData!.user?.id ?? existingUserId ?? '',
        );

        // Store role
        await _authStorageService.storeSelectedRole(responseData!.role);

        DPrint.log("✅ Tokens stored successfully");
        setLoading(false);
        return responseData; // Return the full response data
      } catch (e) {
        DPrint.log("❌ Error storing tokens: $e");
        setLoading(false);
        return null;
      }
    } else {
      // Token refresh failed
      try {
        await _authStorageService.clearAuthData(); // clear invalid token
        DPrint.log("✅ Invalid tokens cleared from storage");
      } catch (e) {
        DPrint.log("⚠️ Error clearing tokens: $e");
      }
      setLoading(false);
      return null; // Return null on failure
    }
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
    // Disconnect socket before clearing auth data
    DPrint.log("🔌 Disconnecting Socket Server...");
    try {
      final socketService = SocketService();
      await socketService.disconnect();
      DPrint.log("✅ Socket disconnected");
    } catch (e) {
      DPrint.error("⚠️ Socket disconnection error: $e");
    }

    await _authStorageService.clearAuthData();
    
    // Clear user profile
    final userController = Get.find<UserController>();
    userController.clearUserProfile();
    
    // Clear categories
    final categoryController = Get.find<CategoryController>();
    categoryController.clearCategories();
    
    // Clear services
    final serviceController = Get.find<ServiceController>();
    serviceController.clearServices();
    
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
    
    // Navigate to login screen
    Get.offAll(() => const LoginScreen());
  }

  /// Connect to Socket Server after login
  Future<void> _connectSocketAfterLogin(String userId, String accessToken) async {
    try {
      final socketService = SocketService();
      await socketService.connect(userId, token: accessToken);
      DPrint.log("✅ Socket connection initiated for user: $userId");
    } catch (e) {
      DPrint.error("❌ Socket connection error: $e");
      // Don't block login even if socket connection fails
    }
  }
}
