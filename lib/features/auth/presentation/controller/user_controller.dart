import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:izu/core/network/api_client.dart';
import 'package:izu/core/utils/debug_print.dart';

import '../../data/model/user_profile_model.dart';

class UserController extends GetxController {
  final Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);
  final RxBool isLoadingProfile = RxBool(false);
  final RxBool isUpdatingProfile = RxBool(false);
  final RxBool isChangingPassword = RxBool(false);

  bool get isProfileLoaded => userProfile.value != null;
  String get userName => userProfile.value?.name ?? 'User';
  String get userEmail => userProfile.value?.email ?? '';
  String? get userProfileImage => userProfile.value?.profileImage;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// Fetch user profile from /api/v1/profile endpoint
  Future<void> fetchUserProfile() async {
    try {
      isLoadingProfile.value = true;
      DPrint.log("🔄 Fetching user profile...");

      final apiClient = ApiClient();
      final result = await apiClient.get<UserProfileModel>(
        '/api/v1/profile',
        fromJsonT: (json) => UserProfileModel.fromJson(json as Map<String, dynamic>),
      );

      result.fold(
        (failure) {
          DPrint.log("❌ Failed to fetch profile: ${failure.message}");
        },
        (success) {
          DPrint.log("✅ Profile fetched: ${success.data.name}");
          userProfile.value = success.data;
        },
      );
    } catch (e) {
      DPrint.log("❌ Exception fetching profile: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  /// Update user profile with name and/or image
  Future<bool> updateUserProfile({
    required String name,
    String? imagePath,
  }) async {
    try {
      isUpdatingProfile.value = true;
      DPrint.log("🔄 Updating profile...");

      final formData = dio.FormData();
      formData.fields.add(MapEntry('name', name));

      // Add image file if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        final imageFile = await dio.MultipartFile.fromFile(imagePath);
        formData.files.add(MapEntry('profileImage', imageFile));
        DPrint.log("📸 Image added: $imagePath");
      }

      final apiClient = ApiClient();
      final result = await apiClient.patch<UserProfileModel>(
        '/api/v1/profile',
        formData: formData,
        fromJsonT: (json) => UserProfileModel.fromJson(json as Map<String, dynamic>),
        isFormData: true,
      );

      return result.fold(
        (failure) {
          DPrint.log("❌ Failed to update profile: ${failure.message}");
          return false;
        },
        (success) {
          DPrint.log("✅ Profile updated: ${success.data.name}");
          userProfile.value = success.data;
          return true;
        },
      );
    } catch (e) {
      DPrint.log("❌ Exception updating profile: $e");
      return false;
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  void setUserProfile(UserProfileModel profile) {
    userProfile.value = profile;
  }

  void clearUserProfile() {
    userProfile.value = null;
  }

  /// Change password with current, new and confirm password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isChangingPassword.value = true;
      DPrint.log("🔄 Changing password...");

      final apiClient = ApiClient();
      final result = await apiClient.patch<Map<String, dynamic>>(
        '/api/v1/profile/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      return result.fold(
        (failure) {
          DPrint.log("❌ Failed to change password: ${failure.message}");
          return false;
        },
        (success) {
          DPrint.log("✅ Password changed successfully!");
          return true;
        },
      );
    } catch (e) {
      DPrint.log("❌ Exception changing password: $e");
      return false;
    } finally {
      isChangingPassword.value = false;
    }
  }
}
