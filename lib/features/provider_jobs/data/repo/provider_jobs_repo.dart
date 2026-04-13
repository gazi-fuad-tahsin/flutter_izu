import '../model/provider_service_model.dart';

abstract class ProviderJobsRepository {
  Future<List<ProviderServiceModel>> getProviderServices();
  Future<void> deleteService(String serviceId);
  Future<void> updateService(ProviderServiceModel service);
  Future<void> addService(ProviderServiceModel service);
}
