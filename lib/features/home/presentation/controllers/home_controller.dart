import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:izu/core/network/services/socket_service.dart';
import 'package:izu/core/utils/debug_print.dart';
import 'package:izu/features/booking/data/model/user_booking_model.dart';
import 'package:izu/features/booking/data/repository/user_booking_repository.dart';

class HomeController extends GetxController {
  SocketService get _socketService => Get.find<SocketService>();
  final _bookingRepository = UserBookingRepository();

  final Rxn<Map<String, dynamic>> requestAcceptedData =
      Rxn<Map<String, dynamic>>();
  final RxBool showAcceptanceDialog = RxBool(false);
  final RxBool isConfirmLoading = RxBool(false);
  final RxBool isCancelLoading = RxBool(false);

  // Completed request state
  final Rxn<Map<String, dynamic>> providerCompletedData =
      Rxn<Map<String, dynamic>>();
  final RxBool showCompletionDialog = RxBool(false);
  final RxBool isCompletionConfirmLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    DPrint.log('🏠 HomeController initialized');
    _listenToRequestConfirmation();
    _listenToProviderCompletedRequest();
  }

  void _listenToRequestConfirmation() {
    DPrint.log('👂 Setting up listener for request-confirmation events');
    ever(_socketService.requestConfirmation, (data) {
      DPrint.log('📥 Request confirmation event received: $data');
      if (data != null) {
        requestAcceptedData.value = data;
        showAcceptanceDialog.value = true;
      }
    });
  }

  void _listenToProviderCompletedRequest() {
    DPrint.log('👂 Setting up listener for provider-completed-request events');
    ever(_socketService.providerCompletedRequest, (data) {
      DPrint.log('📥 Provider completed request event received: $data');
      if (data != null) {
        providerCompletedData.value = data;
        showCompletionDialog.value = true;
      }
    });
  }

  String? get _bookingId {
    final data = requestAcceptedData.value;
    if (data == null) return null;
    final booking = data['booking'];
    if (booking is Map) {
      final id = booking['_id'];
      if (id is String && id.isNotEmpty) return id;
    }
    final fallback = data['bookingId'] ?? data['_id'];
    return fallback is String ? fallback : null;
  }

  /// Confirm booking — PATCH /bookings/confirm/:bookingId
  Future<bool> acceptProviderRequest() async {
    final bookingId = _bookingId;
    if (bookingId == null || bookingId.isEmpty) {
      DPrint.error('❌ No bookingId found in socket data');
      return false;
    }

    isConfirmLoading.value = true;
    final result = await _bookingRepository.confirmBooking(bookingId);
    isConfirmLoading.value = false;

    showAcceptanceDialog.value = false;
    requestAcceptedData.value = null;

    if (result != null) {
      DPrint.log('✅ Booking confirmed: ${result.id}');
      return true;
    } else {
      DPrint.error('❌ Failed to confirm booking');
      return false;
    }
  }

  /// Confirm completion — PATCH /bookings/confirm-completion/:bookingId
  Future<UserBookingModel?> acceptProviderCompletion() async {
    final data = providerCompletedData.value;
    if (data == null) return null;

    // Extract bookingId
    String? bookingId;
    final booking = data['booking'];
    if (booking is Map) {
      bookingId = booking['_id'];
    }
    bookingId ??= data['bookingId'] ?? data['_id'];

    if (bookingId == null || bookingId.isEmpty) {
      DPrint.error('❌ No bookingId found in provider completion data');
      return null;
    }

    isCompletionConfirmLoading.value = true;
    final result = await _bookingRepository.confirmCompletion(bookingId);
    isCompletionConfirmLoading.value = false;

    showCompletionDialog.value = false;
    providerCompletedData.value = null;

    if (result != null) {
      DPrint.log('✅ Service completion confirmed: ${result.id}');
      Get.snackbar(
        'Success',
        'Service completion confirmed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      DPrint.error('❌ Failed to confirm service completion');
      Get.snackbar(
        'Error',
        'Failed to confirm service completion',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    return result;
  }

  Future<CompletionPaymentFlowResult?> acceptCompletionAndCreatePayment({
    required Map<String, dynamic> completionData,
  }) async {
    String? bookingId;
    String? providerId;
    double price = 0;

    final booking = completionData['booking'];
    if (booking is Map) {
      bookingId = booking['_id']?.toString();
      final bookingProvider = booking['providerId'];
      if (bookingProvider is Map) {
        providerId = bookingProvider['_id']?.toString();
      } else {
        providerId = bookingProvider?.toString();
      }
      price = (booking['totalPrice'] as num?)?.toDouble() ?? 0;
    }

    bookingId ??= completionData['bookingId']?.toString() ?? completionData['_id']?.toString();
    final providerData = completionData['providerId'];
    if (providerId == null || providerId.isEmpty) {
      if (providerData is Map) {
        providerId = providerData['_id']?.toString();
      } else {
        providerId = providerData?.toString();
      }
    }
    if (price <= 0) {
      price = (completionData['totalPrice'] as num?)?.toDouble() ?? 0;
    }

    if (bookingId == null || bookingId.isEmpty || providerId == null || providerId.isEmpty || price <= 0) {
      DPrint.error('❌ Missing payment payload fields from completion socket data');
      Get.snackbar(
        'Error',
        'Missing payment information',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }

    isCompletionConfirmLoading.value = true;
    try {
      final confirmedBooking = await _bookingRepository.confirmCompletion(bookingId);
      if (confirmedBooking == null) {
        DPrint.error('❌ Failed to confirm service completion');
        Get.snackbar(
          'Error',
          'Failed to confirm service completion',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }

      final clientSecret = await _bookingRepository.createBookingPayment(
        price: price,
        bookingId: bookingId,
        providerId: providerId,
      );

      if (clientSecret == null || clientSecret.isEmpty) {
        DPrint.error('❌ Failed to create payment intent');
        Get.snackbar(
          'Error',
          'Failed to initialize payment',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }

      showCompletionDialog.value = false;
      providerCompletedData.value = null;

      return CompletionPaymentFlowResult(
        booking: confirmedBooking,
        amount: price,
        clientSecret: clientSecret,
      );
    } finally {
      isCompletionConfirmLoading.value = false;
    }
  }

  void cancelProviderCompletion() {
    showCompletionDialog.value = false;
    providerCompletedData.value = null;
  }

  /// Cancel booking — PATCH /bookings/cancel/:bookingId
  Future<void> confirmCancelBooking() async {
    final bookingId = _bookingId;
    if (bookingId == null || bookingId.isEmpty) {
      DPrint.error('❌ No bookingId found in socket data');
      Get.back();
      return;
    }

    isCancelLoading.value = true;
    final result = await _bookingRepository.cancelBooking(bookingId);
    isCancelLoading.value = false;

    if (result != null) {
      DPrint.log('✅ Booking cancelled: ${result.id}');
      Get.back(); // close cancel confirmation dialog
      Get.back(); // close provider ready dialog
      requestAcceptedData.value = null;
      showAcceptanceDialog.value = false;
      Get.snackbar(
        'Success',
        'Booking cancel successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      DPrint.error('❌ Failed to cancel booking');
      Get.snackbar(
        'Error',
        'Failed to cancel booking',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  void onClose() {
    DPrint.log('🏠 HomeController closed');
    super.onClose();
  }
}

class CompletionPaymentFlowResult {
  final UserBookingModel booking;
  final double amount;
  final String clientSecret;

  const CompletionPaymentFlowResult({
    required this.booking,
    required this.amount,
    required this.clientSecret,
  });
}
