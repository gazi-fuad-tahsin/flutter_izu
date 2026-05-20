import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/constants/api_constants.dart';
import '../../../../../core/utils/debug_print.dart';
import '../model/user_booking_model.dart';

class UserBookingRepository {
  final _apiClient = ApiClient();

  /// PATCH /bookings/confirm/:bookingId
  Future<UserBookingModel?> confirmBooking(String bookingId) async {
    try {
      DPrint.log('🔄 Confirming booking: $bookingId');
      final result = await _apiClient.patch<Map<String, dynamic>>(
        ApiConstants.booking.confirmBooking(bookingId),
        fromJsonT: (json) => json is Map<String, dynamic> ? json : {},
      );
      return result.fold(
        (failure) {
          DPrint.error('❌ Confirm booking failed: ${failure.message}');
          return null;
        },
        (success) {
          DPrint.log('✅ Booking confirmed');
          return UserBookingModel.fromJson(success.data);
        },
      );
    } catch (e) {
      DPrint.error('❌ Exception confirming booking: $e');
      return null;
    }
  }

  /// PATCH /bookings/confirm-completion/:bookingId
  Future<UserBookingModel?> confirmCompletion(String bookingId) async {
    try {
      DPrint.log('🔄 Confirming booking completion: $bookingId');
      final result = await _apiClient.patch<Map<String, dynamic>>(
        ApiConstants.booking.confirmCompletion(bookingId),
        fromJsonT: (json) => json is Map<String, dynamic> ? json : {},
      );
      return result.fold(
        (failure) {
          DPrint.error('❌ Confirm completion failed: ${failure.message}');
          return null;
        },
        (success) {
          DPrint.log('✅ Booking completion confirmed');
          return UserBookingModel.fromJson(success.data);
        },
      );
    } catch (e) {
      DPrint.error('❌ Exception confirming booking completion: $e');
      return null;
    }
  }

  /// PATCH /bookings/cancel/:bookingId
  Future<UserBookingModel?> cancelBooking(String bookingId) async {
    try {
      DPrint.log('🔄 Cancelling booking: $bookingId');
      final result = await _apiClient.patch<Map<String, dynamic>>(
        ApiConstants.booking.cancelBooking(bookingId),
        fromJsonT: (json) => json is Map<String, dynamic> ? json : {},
      );
      return result.fold(
        (failure) {
          DPrint.error('❌ Cancel booking failed: ${failure.message}');
          return null;
        },
        (success) {
          DPrint.log('✅ Booking cancelled');
          return UserBookingModel.fromJson(success.data);
        },
      );
    } catch (e) {
      DPrint.error('❌ Exception cancelling booking: $e');
      return null;
    }
  }

  /// Fetch user bookings by status
  /// Endpoints:
  /// - 'live' -> /api/v1/bookings/live
  /// - 'upcoming' -> /api/v1/bookings/upcoming
  /// - 'completed' -> /api/v1/bookings/completed
  /// - 'cancelled' -> /api/v1/bookings/cancelled
  Future<List<UserBookingModel>> getBookingsByStatus(String status) async {
    try {
      late String endpoint;

      // Route to correct endpoint based on status
      if (status == 'live') {
        endpoint = '/api/v1/bookings/live';
      } else if (status == 'upcoming') {
        endpoint = '/api/v1/bookings/upcoming';
      } else if (status == 'completed') {
        endpoint = '/api/v1/bookings/completed';
      } else if (status == 'cancelled') {
        endpoint = '/api/v1/bookings/cancelled';
      } else {
        endpoint = '/api/v1/bookings/$status';
      }

      DPrint.log('🔄 Fetching $status bookings from $endpoint...');

      final result = await _apiClient.get<dynamic>(
        endpoint,
        fromJsonT: (json) => json,
      );

      return result.fold(
        (failure) {
          DPrint.log('❌ Failed to fetch $status bookings: ${failure.message}');
          throw Exception(failure.message);
        },
        (success) {
          // All responses are direct arrays
          final dataList = success.data as List<dynamic>;

          DPrint.log('✅ Bookings fetched: ${dataList.length} items');

          final bookings = dataList
              .map((item) => UserBookingModel.fromJson(item as Map<String, dynamic>))
              .toList();

          DPrint.log('✅ Parsed $status bookings: ${bookings.length}');
          return bookings;
        },
      );
    } catch (e) {
      DPrint.log('❌ Exception fetching $status bookings: $e');
      return [];
    }
  }
}
