import 'package:izu/core/network/api_client.dart';
import 'package:izu/core/utils/debug_print.dart';

import '../model/provider_profile_model.dart';
import 'provider_profile_repo.dart';

class ProviderProfileRepositoryImpl extends ProviderProfileRepository {
  final _apiClient = ApiClient();

  @override
  Future<ProviderProfileModel> getProfileData() async {
    try {
      DPrint.log('🔄 Fetching provider profile from /api/v1/profile/provider...');

      final result = await _apiClient.get<Map<String, dynamic>>(
        '/api/v1/profile/provider',
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      return result.fold(
        (failure) {
          DPrint.log('❌ Failed to fetch provider profile: ${failure.message}');
          throw Exception(failure.message);
        },
        (success) {
          DPrint.log('✅ Provider profile response: ${success.data}');
          // Extract data if it's wrapped
          final responseData = success.data['data'] ?? success.data;
          final profile = ProviderProfileModel.fromJson(responseData as Map<String, dynamic>);
          DPrint.log('✅ Provider profile fetched: ${profile.name}');
          return profile;
        },
      );
    } catch (e) {
      DPrint.log('❌ Exception fetching provider profile: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(ProviderProfileModel profile) async {
    try {
      DPrint.log('🔄 Updating provider profile...');
      
      final result = await _apiClient.patch<Map<String, dynamic>>(
        '/api/v1/profile/provider',
        data: profile.toJson(),
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      result.fold(
        (failure) {
          DPrint.log('❌ Failed to update provider profile: ${failure.message}');
          throw Exception(failure.message);
        },
        (success) {
          DPrint.log('✅ Provider profile updated');
        },
      );
    } catch (e) {
      DPrint.log('❌ Exception updating provider profile: $e');
      rethrow;
    }
  }
}
