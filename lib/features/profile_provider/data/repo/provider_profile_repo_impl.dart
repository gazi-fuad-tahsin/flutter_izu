import '../model/provider_profile_model.dart';
import 'provider_profile_repo.dart';

class ProviderProfileRepositoryImpl extends ProviderProfileRepository {
  // TODO: Implement API calls using ApiClient
  // For now, returning mock data

  @override
  Future<ProviderProfileModel> getProfileData() async {
    try {
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/provider/profile');
      // return ProviderProfileModel.fromJson(response);

      // Mock data for now
      await Future.delayed(const Duration(milliseconds: 500));
      return ProviderProfileModel(
        id: '1',
        name: 'Mr. Khaled',
        email: 'khaled@abcmail.com',
        phone: '565235612021',
        profileImage: null,
        rating: 5.0,
        completedServices: 30,
        earnings: 5000.0,
        handle: '@service_provider',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(ProviderProfileModel profile) async {
    try {
      // TODO: Replace with actual API call
      // await apiClient.put('/provider/profile', profile.toJson());
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      rethrow;
    }
  }
}
