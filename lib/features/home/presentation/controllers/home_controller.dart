import 'package:get/get.dart';
import 'package:izu/core/network/services/socket_service.dart';
import 'package:izu/core/utils/debug_print.dart';
import 'package:izu/features/booking/data/repository/user_booking_repository.dart';

class HomeController extends GetxController {
  SocketService get _socketService => Get.find<SocketService>();
  final _bookingRepository = UserBookingRepository();

  final Rxn<Map<String, dynamic>> requestAcceptedData =
      Rxn<Map<String, dynamic>>();
  final RxBool showAcceptanceDialog = RxBool(false);
  final RxBool isConfirmLoading = RxBool(false);
  final RxBool isCancelLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    DPrint.log('🏠 HomeController initialized');
    _listenToRequestConfirmation();
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
  Future<void> acceptProviderRequest() async {
    final bookingId = _bookingId;
    if (bookingId == null || bookingId.isEmpty) {
      DPrint.error('❌ No bookingId found in socket data');
      Get.back();
      return;
    }

    isConfirmLoading.value = true;
    final result = await _bookingRepository.confirmBooking(bookingId);
    isConfirmLoading.value = false;

    showAcceptanceDialog.value = false;
    Get.back();

    if (result != null) {
      DPrint.log('✅ Booking confirmed: ${result.id}');
    } else {
      DPrint.error('❌ Failed to confirm booking');
    }
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

    Get.back(); // close cancel confirmation dialog
    requestAcceptedData.value = null;

    if (result != null) {
      DPrint.log('✅ Booking cancelled: ${result.id}');
    } else {
      DPrint.error('❌ Failed to cancel booking');
    }
  }

  @override
  void onClose() {
    DPrint.log('🏠 HomeController closed');
    super.onClose();
  }
}
