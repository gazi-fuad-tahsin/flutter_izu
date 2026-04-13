import 'package:get/get.dart';

import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import '../../features/category/data/repo/category_repo_impl.dart';
import '../../features/category/domain/repo/category_repo.dart';
import '../../features/service/data/repo/service_repo_impl.dart';
import '../../features/service/domain/repo/service_repo.dart';

void setupRepository() {
  Get.put<AuthRepository>(
    AuthRepositoryImpl(apiClient: Get.find()),
    permanent: true,
  );

  Get.put<CategoryRepository>(
    CategoryRepositoryImpl(apiClient: Get.find()),
    permanent: true,
  );

  Get.put<ServiceRepository>(
    ServiceRepositoryImpl(apiClient: Get.find()),
    permanent: true,
  );
  
}
