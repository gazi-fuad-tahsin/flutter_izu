import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/constants/api_constants.dart';
import '../../../../../core/utils/debug_print.dart';

class RatingRepository {
  final _apiClient = ApiClient();

  /// POST /bookings/review/:bookingId
  /// Submits a booking review & rating
  Future<bool> submitBookingReview({
    required String bookingId,
    required String serviceId,
    required double rating,
    required String message,
  }) async {
    try {
      DPrint.log('🔄 Submitting review for booking $bookingId: $rating stars');
      
      final body = {
        "serviceId": serviceId,
        "rating": rating,
        "message": message,
      };

      final result = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.booking.submitReview(bookingId),
        data: body,
        fromJsonT: (json) => json is Map<String, dynamic> ? json : {},
      );

      return result.fold(
        (failure) {
          DPrint.error('❌ Failed to submit booking review: ${failure.message}');
          return false;
        },
        (success) {
          DPrint.log('✅ Booking review submitted successfully');
          return true;
        },
      );
    } catch (e) {
      DPrint.error('❌ Exception submitting booking review: $e');
      return false;
    }
  }

  /// POST /rating (Old method kept for reference)
  Future<bool> submitRating({
    required String bookingId,
    required String serviceId,
    required String providerId,
    required double rating,
    required String comment,
  }) async {
    try {
      DPrint.log('🔄 Submitting rating: $rating stars for provider: $providerId');
      
      final body = {
        "bookingId": bookingId,
        "serviceId": serviceId,
        "providerId": providerId,
        "rating": rating,
        "comment": comment,
      };

      final result = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.rating.submitRating,
        data: body,
        fromJsonT: (json) => json is Map<String, dynamic> ? json : {},
      );

      return result.fold(
        (failure) {
          DPrint.error('❌ Failed to submit rating: ${failure.message}');
          return false;
        },
        (success) {
          DPrint.log('✅ Rating submitted successfully');
          return true;
        },
      );
    } catch (e) {
      DPrint.error('❌ Exception submitting rating: $e');
      return false;
    }
  }
}
