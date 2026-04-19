import 'package:get/get.dart';
import 'package:izu/core/network/services/socket_service.dart';
import 'package:izu/core/utils/debug_print.dart';

class HomeController extends GetxController {
  /// Getter for SocketService - retrieves when needed
  SocketService get _socketService => Get.find<SocketService>();

  // Observable for request-accepted event
  final Rxn<Map<String, dynamic>> requestAcceptedData =
      Rxn<Map<String, dynamic>>();
  final RxBool showAcceptanceDialog = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    DPrint.log('🏠 HomeController initialized');
    _listenToRequestAccepted();
  }

  /// Listen to request-accepted event from socket
  void _listenToRequestAccepted() {
    DPrint.log('👂 Setting up listener for request-accepted events');
    
    // Listen to socket service's requestAccepted observable
    ever(_socketService.requestAccepted, (data) {
      DPrint.log(
          '📥 [OBSERVABLE TRIGGERED] Request accepted event received: $data');
      if (data != null) {
        DPrint.log(
            '✅ [DIALOG TRIGGER] Showing acceptance dialog for: ${data['providerName']}');
        requestAcceptedData.value = data;
        showAcceptanceDialog.value = true;
        
        // Log to confirm state changed
        DPrint.log('🔔 Dialog visibility: ${showAcceptanceDialog.value}');
      } else {
        DPrint.log('⚠️ Received null data in request-accepted event');
      }
    });
  }

  /// Handle user accepting the provider's request
  void acceptProviderRequest() {
    DPrint.log(
        '✅ User accepted provider request: ${requestAcceptedData.value?['bookingId']}');
    showAcceptanceDialog.value = false;
    // TODO: Implement API call to confirm user acceptance
    Get.back();
  }

  /// Handle user cancelling the provider's request
  void cancelProviderRequest() {
    DPrint.log(
        '❌ User cancelled provider request: ${requestAcceptedData.value?['bookingId']}');
    showAcceptanceDialog.value = false;
    // TODO: Implement API call to reject provider's acceptance
    Get.back();
  }

  @override
  void onClose() {
    DPrint.log('🏠 HomeController closed');
    super.onClose();
  }
}
