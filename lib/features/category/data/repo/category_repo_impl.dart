import 'package:izu/core/network/api_client.dart';
import 'package:izu/core/network/network_result.dart';
import 'package:izu/core/utils/debug_print.dart';

import '../../domain/repo/category_repo.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final ApiClient apiClient;

  CategoryRepositoryImpl({required this.apiClient});

  @override
  NetworkResult<List<CategoryModel>> fetchCategories() {
    // Use full API path like profile endpoint
    const endpoint = '/api/v1/categories';
    DPrint.log("🔗 Categories Endpoint: $endpoint");
    
    return apiClient.get<List<CategoryModel>>(
      endpoint,
      fromJsonT: (json) {
        DPrint.log("📦 Categories fromJsonT received - Type: ${json.runtimeType}");
        DPrint.log("📦 JSON Content: $json");
        
        if (json is List) {
          DPrint.log("✅ Response is List, parsing ${json.length} items");
          final categories = json.map((item) {
            DPrint.log("   Parsing category: ${(item as Map)['name']}");
            return CategoryModel.fromJson(item as Map<String, dynamic>);
          }).toList();
          DPrint.log("✅ Successfully parsed ${categories.length} categories");
          return categories;
        } else if (json is Map) {
          DPrint.log("⚠️ Response is Map, not List. Checking for categories field...");
          if (json.containsKey('categories')) {
            final categories = (json['categories'] as List);
            return categories.map((item) => CategoryModel.fromJson(item as Map<String, dynamic>)).toList();
          }
          throw Exception('Backend returned Map instead of List. Response: $json');
        }
        throw Exception('Unexpected response type: ${json.runtimeType}. Expected List or Map.');
      },
    );
  }
}
