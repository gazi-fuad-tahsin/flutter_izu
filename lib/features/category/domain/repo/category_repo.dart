import 'package:izu/core/network/network_result.dart';

import '../../data/models/category_model.dart';

abstract class CategoryRepository {
  NetworkResult<List<CategoryModel>> fetchCategories();
}
