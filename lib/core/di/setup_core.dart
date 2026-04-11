import 'package:get/get.dart';

import '../network/api_client.dart';
import '../network/services/auth_storage_service.dart';
import '../services/google_maps_service.dart';
import '../services/google_places_service.dart';
import '../services/location_service.dart';
import '../services/saved_location_service.dart';

Future<void> setupCore() async {
  Get.put<ApiClient>(ApiClient());
  Get.put<AuthStorageService>(AuthStorageService());
}
