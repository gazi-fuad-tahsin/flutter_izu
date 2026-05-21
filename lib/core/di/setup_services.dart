
import 'package:get/get.dart';

import '../../features/message/presentation/controller/call_controller.dart';
import '../network/services/socket_service.dart';
import '../services/notification_sound_service.dart';

void setupServices() {
  // Register SocketService as a singleton (GetxService)
  Get.put<SocketService>(SocketService(), permanent: true);

  // CallController depends on SocketService — must be registered after it
  Get.put<CallController>(CallController(), permanent: true);

  // Notification sound — singleton so the player is reused across calls
  Get.put<NotificationSoundService>(NotificationSoundService(), permanent: true);
}
