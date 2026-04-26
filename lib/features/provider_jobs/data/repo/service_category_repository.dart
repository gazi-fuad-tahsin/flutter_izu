import 'package:izu/core/network/api_client.dart';
import 'package:izu/core/utils/debug_print.dart';

import '../model/service_category_model.dart';

class ServiceCategoryRepository {
  final _apiClient = ApiClient();

  /// Fetch all service categories
  Future<List<ServiceCategoryModel>> getServiceCategories() async {
    try {
      DPrint.log('🔄 Fetching service categories from /api/v1/categories...');

      final result = await _apiClient.get<dynamic>(
        '/api/v1/categories',
        fromJsonT: (json) => json,
      );

      return result.fold(
        (failure) {
          DPrint.log('❌ Failed to fetch categories: ${failure.message}');
          throw Exception(failure.message);
        },
        (success) {
          DPrint.log('✅ Categories response: ${success.data}');
          
          final categoriesList = success.data as List<dynamic>;
          final categories = categoriesList
              .where((item) => (item['isActive'] as bool?) ?? true) // Filter active categories
              .map((item) => ServiceCategoryModel.fromJson(item as Map<String, dynamic>))
              .toList();
          
          DPrint.log('✅ Parsed ${categories.length} active categories');
          return categories;
        },
      );
    } catch (e) {
      DPrint.log('❌ Exception fetching categories: $e');
      rethrow;
    }
  }
}
