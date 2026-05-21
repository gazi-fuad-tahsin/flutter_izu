import '../model/provider_profile_model.dart';
import '../model/provider_stats_model.dart';

abstract class ProviderProfileRepository {
  Future<ProviderProfileModel> getProfileData();
  Future<ProviderStatsModel> getProviderStats();
  Future<void> updateProfile(ProviderProfileModel profile);
}
