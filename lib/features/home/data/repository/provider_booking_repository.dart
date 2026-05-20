import 'package:izu/core/network/api_client.dart';
import 'package:izu/core/utils/debug_print.dart';

import '../model/provider_booking_model.dart';

class ProviderBookingRepository {
  final _apiClient = ApiClient();

  /// Fetch bookings for a specific status
  /// Possible statuses: live, next, completed, cancelled
  Future<List<ProviderBooking>> getBookingsByStatus(String status) async {
    try {
      String endpoint;

      if (status == 'live') {
        endpoint = '/api/v1/providers/live-bookings';
      } else if (status == 'next') {
        endpoint = '/api/v1/providers/upcoming-bookings';
      } else if (status == 'completed' || status == 'cancelled') {
        endpoint = '/api/v1/providers/completed-cancelled-bookings';
      } else {
        endpoint = '/api/v1/bookings/$status';
      }

      DPrint.log('🔄 Fetching $status bookings from $endpoint...');

      final result = await _apiClient.get<dynamic>(
        endpoint,
        fromJsonT: (json) => json,
      );

      return result.fold((failure) {
        DPrint.log('❌ Failed to fetch $status bookings: ${failure.message}');
        throw Exception(failure.message);
      }, (success) {
        List<dynamic> dataList = [];

        if (status == 'completed' || status == 'cancelled') {
          final responseMap = success.data as Map<String, dynamic>;
          dataList = (responseMap[status] as List<dynamic>?) ?? [];
        } else {
          dataList = success.data as List<dynamic>;
        }

        DPrint.log('✅ Bookings fetched: ${dataList.length} items');

        final bookings = dataList
            .map((item) => ProviderBooking.fromJson(item as Map<String, dynamic>))
            .toList();

        DPrint.log('✅ Parsed $status bookings: ${bookings.length}');
        return bookings;
      });
    } catch (e) {
      DPrint.log('❌ Exception fetching $status bookings: $e');
      return [];
    }
  }

  /// Fetch all booking statuses
  Future<Map<String, List<ProviderBooking>>> getAllBookings() async {
    try {
      DPrint.log('🔄 Fetching all bookings...');

      final statuses = ['live', 'next', 'completed', 'cancelled'];
      final allBookings = <String, List<ProviderBooking>>{};

      for (final status in statuses) {
        final bookings = await getBookingsByStatus(status);
        allBookings[status] = bookings;
      }

      DPrint.log('✅ All bookings fetched');
      return allBookings;
    } catch (e) {
      DPrint.log('❌ Exception fetching all bookings: $e');
      return {
        'live': [],
        'next': [],
        'completed': [],
        'cancelled': [],
      };
    }
  }

  /// Start service for a booking (provider action)
  /// Returns true on success, false otherwise
  Future<bool> startService(String bookingId) async {
    try {
      final endpoint = '/api/v1/providers/start-service/$bookingId';
      DPrint.log('🔄 Starting service for booking $bookingId');

      final result = await _apiClient.patch<Map<String, dynamic>>(
        endpoint,
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      return result.fold((failure) {
        DPrint.log('❌ Failed to start service: ${failure.message}');
        return false;
      }, (success) {
        DPrint.log('✅ Start service response: ${success.data}');
        return true;
      });
    } catch (e) {
      DPrint.log('❌ Exception starting service: $e');
      return false;
    }
  }

  /// Complete service for a booking (provider action)
  /// Returns true on success, false otherwise
  Future<bool> completeBooking(String bookingId) async {
    try {
      final endpoint = '/api/v1/providers/complete-booking/$bookingId';
      DPrint.log('🔄 Completing booking $bookingId');

      final result = await _apiClient.patch<Map<String, dynamic>>(
        endpoint,
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      return result.fold((failure) {
        DPrint.log('❌ Failed to complete booking: ${failure.message}');
        return false;
      }, (success) {
        DPrint.log('✅ Complete booking response: ${success.data}');
        return true;
      });
    } catch (e) {
      DPrint.log('❌ Exception completing booking: $e');
      return false;
    }
  }
}
