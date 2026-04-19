import '../../../../../core/network/api_client.dart';
import '../../../../../core/utils/debug_print.dart';
import '../model/user_booking_model.dart';

class UserBookingRepository {
  final _apiClient = ApiClient();

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
