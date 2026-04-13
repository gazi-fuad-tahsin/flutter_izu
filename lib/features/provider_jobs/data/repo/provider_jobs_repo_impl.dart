import '../model/provider_service_model.dart';
import 'provider_jobs_repo.dart';

class ProviderJobsRepositoryImpl extends ProviderJobsRepository {
  @override
  Future<List<ProviderServiceModel>> getProviderServices() async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data matching the image
      return [
        ProviderServiceModel(
          id: '1',
          title: 'Plumber',
          category: 'Plumbing',
          image: 'assets/images/plumber.jpg',
          providerName: 'Mrs. Rani',
          providerHandle: '@Service Provider',
          rating: 4.8,
          distance: 2.5,
          pricePerHour: 45.0,
        ),
        ProviderServiceModel(
          id: '2',
          title: 'Plumber',
          category: 'Plumbing',
          image: 'assets/images/plumber.jpg',
          providerName: 'Mrs. Rani',
          providerHandle: '@Service Provider',
          rating: 4.8,
          distance: 2.5,
          pricePerHour: 45.0,
        ),
      ];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteService(String serviceId) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateService(ProviderServiceModel service) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addService(ProviderServiceModel service) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      rethrow;
    }
  }
}
