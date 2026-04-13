import 'package:get/get.dart';

import '../network/api_client.dart';
import '../network/services/auth_storage_service.dart';

Future<void> setupCore() async {
  Get.put<ApiClient>(ApiClient());
  Get.put<AuthStorageService>(AuthStorageService());
}
