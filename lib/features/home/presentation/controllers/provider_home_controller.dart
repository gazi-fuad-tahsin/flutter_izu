import 'package:get/get.dart';

import '../../data/model/pending_request_model.dart';
import '../../data/repository/provider_home_repository.dart';

class ProviderHomeController extends GetxController {
  final ProviderHomeRepository _repository = ProviderHomeRepository();

  final RxList<PendingRequest> pendingRequests = RxList<PendingRequest>();
  final RxBool isLoading = RxBool(false);
  final RxString errorMessage = RxString('');

  @override
  void onInit() {
    super.onInit();
    fetchPendingRequests();
  }

  Future<void> fetchPendingRequests() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _repository.getPendingRequests();

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          isLoading.value = false;
        },
        (success) {
          pendingRequests.value = success.data;
          isLoading.value = false;
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      isLoading.value = false;
    }
  }

  void acceptRequest(String requestId) {
    // TODO: Implement accept request API call
    Get.snackbar('Success', 'Request accepted successfully');
  }

  void rejectRequest(String requestId) {
    // TODO: Implement reject request API call
    Get.snackbar('Cancelled', 'Request cancelled successfully');
  }
}
