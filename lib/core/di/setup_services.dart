import 'package:get/get.dart';

import '../services/socket_service.dart';
import '../services/sound_service.dart';

void setupServices() {
  // Get.lazyPut<GetUserProfileService>(() => GetUserProfileService(Get.find()));

  // Register SoundService as a permanent singleton (available app-wide)
  // Get.put<SoundService>(SoundService(), permanent: true);

  // // Register SocketService as a singleton
  // Get.put<SocketService>(SocketService(), permanent: true);
}
