import 'package:izu/core/network/api_client.dart';
import 'package:izu/core/utils/debug_print.dart';

import '../model/provider_service_model.dart';
import 'provider_jobs_repo.dart';

class ProviderJobsRepositoryImpl extends ProviderJobsRepository {
  final _apiClient = ApiClient();

  @override
  Future<List<ProviderServiceModel>> getProviderServices() async {
    try {
      DPrint.log('🔄 Fetching provider own services from /api/v1/services/own-services...');

      final result = await _apiClient.get<dynamic>(
        '/api/v1/services/own-services',
        fromJsonT: (json) => json,
      );

      return result.fold(
        (failure) {
          DPrint.log('❌ Failed to fetch services: ${failure.message}');
          throw Exception(failure.message);
        },
        (success) {
          DPrint.log('✅ Services response: ${success.data}');
          
          final servicesList = success.data as List<dynamic>;
          final services = servicesList
              .map((item) => ProviderServiceModel.fromJson(item as Map<String, dynamic>))
              .toList();
          
          DPrint.log('✅ Parsed ${services.length} services');
          return services;
        },
      );
    } catch (e) {
      DPrint.log('❌ Exception fetching services: $e');
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
