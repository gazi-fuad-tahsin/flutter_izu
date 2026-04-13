import '../model/provider_profile_model.dart';

abstract class ProviderProfileRepository {
  Future<ProviderProfileModel> getProfileData();
  Future<void> updateProfile(ProviderProfileModel profile);
}
