import 'package:get/get.dart';

import '../../../../../core/base/base_controller.dart';
import '../../../../../core/utils/debug_print.dart';
import '../../data/model/provider_profile_model.dart';
import '../../data/model/provider_stats_model.dart';
import '../../data/repo/provider_profile_repo_impl.dart';

class ProviderProfileController extends BaseController {
  final _repo = ProviderProfileRepositoryImpl();

  final Rx<ProviderProfileModel?> profileData = Rx<ProviderProfileModel?>(null);
  final Rx<ProviderStatsModel?> providerStats = Rx<ProviderStatsModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  /// Fetch provider profile data
  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log('📋 Fetching provider profile data...');

      final profile = await _repo.getProfileData();
      profileData.value = profile;

      try {
        final stats = await _repo.getProviderStats();
        providerStats.value = stats;
      } catch (e) {
        DPrint.log('⚠️ Failed to fetch provider stats: $e');
        providerStats.value = const ProviderStatsModel(
          totalWorkCompletion: 0,
          providerEarnings: 0,
        );
      }

      DPrint.log('✅ Profile data fetched successfully');
    } catch (e) {
      DPrint.log('❌ Error fetching profile: $e');
      errorMessage.value = 'Failed to load profile data';
    } finally {
      isLoading.value = false;
    }
  }

  /// Update provider profile
  Future<void> updateProfile(ProviderProfileModel updatedProfile) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log('📝 Updating provider profile...');

      await _repo.updateProfile(updatedProfile);
      profileData.value = updatedProfile;

      DPrint.log('✅ Profile updated successfully');
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      DPrint.log('❌ Error updating profile: $e');
      errorMessage.value = 'Failed to update profile';
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset controller
  void resetController() {
    profileData.value = null;
    providerStats.value = null;
    errorMessage.value = '';
    isLoading.value = false;
  }
}
