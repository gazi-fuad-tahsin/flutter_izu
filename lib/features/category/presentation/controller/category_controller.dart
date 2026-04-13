import 'package:get/get.dart';
import 'package:izu/features/category/data/models/category_model.dart';
import 'package:izu/features/category/domain/repo/category_repo.dart';

import '../../../../../core/utils/debug_print.dart';

class CategoryController extends GetxController {
  final CategoryRepository categoryRepository;

  CategoryController({required this.categoryRepository});

  final Rx<List<CategoryModel>> _categories = Rx<List<CategoryModel>>([]);

  get categories => _categories.value;
  
  // Top 5 categories for home screen
  List<CategoryModel> get topFiveCategories {
    if (_categories.value.isEmpty) return [];
    return _categories.value.take(5).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      DPrint.log("🔄 Fetching categories...");
      DPrint.log("🛜 Calling endpoint: /categories");
      
      final result = await categoryRepository.fetchCategories();
      
      DPrint.log("📦 Categories Result Type: ${result.runtimeType}");
      
      result.fold(
        (fail) {
          DPrint.log("❌ Failed to fetch categories: ${fail.message}");
          DPrint.log("   Error details: ${fail.toString()}");
        },
        (success) {
          DPrint.log("✅ Categories fetched successfully!");
          DPrint.log("   Received data type: ${success.data.runtimeType}");
          _categories.value = success.data;
          DPrint.log("📦 Loaded ${success.data.length} categories");
          DPrint.log("   Categories: ${success.data.map((c) => '${c.name} (${c.id})').join(', ')}");
        },
      );
    } catch (e) {
      DPrint.log("❌ Exception fetching categories: $e");
      DPrint.log("   Stack trace: ${StackTrace.current}");
    }
  }

  void clearCategories() {
    _categories.value = [];
    DPrint.log("🗑️ Categories cleared");
  }
}
