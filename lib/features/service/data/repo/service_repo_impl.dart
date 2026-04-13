import 'package:izu/core/network/api_client.dart';
import 'package:izu/core/network/network_result.dart';
import 'package:izu/core/utils/debug_print.dart';

import '../../domain/repo/service_repo.dart';
import '../models/service_detail_model.dart';
import '../models/service_model.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ApiClient apiClient;

  ServiceRepositoryImpl({required this.apiClient});

  @override
  NetworkResult<Map<String, List<ServiceModel>>> fetchServices() {
    // Use full API path like profile and categories endpoints
    const endpoint = '/api/v1/services';
    DPrint.log("🔗 Services Endpoint: $endpoint");
    
    return apiClient.get<Map<String, List<ServiceModel>>>(
      endpoint,
      fromJsonT: (json) {
        DPrint.log("📦 Services fromJsonT received - Type: ${json.runtimeType}");
        
        if (json is Map) {
          DPrint.log("✅ Response is Map with category services");
          final result = <String, List<ServiceModel>>{};
          
          json.forEach((key, value) {
            if (value is List) {
              final services = value
                  .map((item) => ServiceModel.fromJson(item as Map<String, dynamic>))
                  .toList();
              result[key as String] = services;
              DPrint.log("   ✅ Parsed category '$key': ${services.length} services");
            }
          });
          
          DPrint.log("✅ Successfully parsed ${result.length} categories with services");
          return result;
        }
        
        throw Exception('Expected Map response, got ${json.runtimeType}');
      },
    );
  }

  @override
  NetworkResult<ServiceDetailModel> fetchServiceDetail(String serviceId) {
    final endpoint = '/api/v1/services/$serviceId';
    DPrint.log("🔗 Service Detail Endpoint: $endpoint");
    
    return apiClient.get<ServiceDetailModel>(
      endpoint,
      fromJsonT: (json) {
        DPrint.log("📦 Service Detail fromJsonT received");
        DPrint.log("   Title: ${json['serviceDetails']?['title']}");
        DPrint.log("   Provider: ${json['providerId']?['name']}");
        
        return ServiceDetailModel.fromJson(json as Map<String, dynamic>);
      },
    );
  }
}
