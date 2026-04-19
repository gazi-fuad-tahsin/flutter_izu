import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izu/core/network/services/socket_service.dart';

import '../../data/model/pending_request_model.dart';
import '../../data/repository/provider_home_repository.dart';

class ProviderHomeController extends GetxController {
  final ProviderHomeRepository _repository = ProviderHomeRepository();

  final RxList<PendingRequest> pendingRequests = RxList<PendingRequest>();
  final RxBool isLoading = RxBool(false);
  final RxString errorMessage = RxString('');

  /// Getter for SocketService - retrieves when needed
  SocketService get _socketService => Get.find<SocketService>();

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

  Future<void> acceptRequest(String requestId) async {
    try {
      isLoading.value = true;

      final result = await _repository.acceptRequest(requestId);

      result.fold(
        (failure) {
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            duration: const Duration(seconds: 2),
          );
          isLoading.value = false;
        },
        (success) {
          Get.snackbar(
            'Success',
            'Booking accepted successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            duration: const Duration(seconds: 2),
          );
          isLoading.value = false;
          
          // Find the full request object to get customer userId and provider name
          final requestIndex = pendingRequests.indexWhere(
            (req) => req.id == requestId,
          );
          
          if (requestIndex >= 0) {
            final request = pendingRequests[requestIndex];
            // Emit socket event to notify user that request has been accepted
            _socketService.emit('request-accepted', {
              'bookingId': requestId,
              'userId': request.userId.id, // Customer ID - server routes to this user
              'providerName': request.providerId.name,
              'providerImage': request.providerId.profileImage,
              'status': 'accepted',
              'message': 'Provider has accepted your request',
              'serviceType': request.serviceId.category?.name ?? 'Service',
              'bookingTime': request.bookingTime,
            });
          } else {
            // Emit without customer ID if request not found (fallback)
            _socketService.emit('request-accepted', {
              'bookingId': requestId,
              'status': 'accepted',
              'message': 'Provider has accepted your request',
            });
          }
          
          // Refresh the pending requests list
          fetchPendingRequests();
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        duration: const Duration(seconds: 2),
      );
      isLoading.value = false;
    }
  }

  void rejectRequest(String requestId) {
    // TODO: Implement reject request API call
    Get.snackbar('Cancelled', 'Request cancelled successfully');
  }
}
