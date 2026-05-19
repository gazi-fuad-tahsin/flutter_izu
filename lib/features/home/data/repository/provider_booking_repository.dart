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
      
      // Determine which endpoint to use based on status
      if (status == 'live') {
        endpoint = '/api/v1/providers/live-bookings';
      } else if (status == 'next') {
        endpoint = '/api/v1/providers/upcoming-bookings';
      } else if (status == 'completed' || status == 'cancelled') {
        endpoint = '/api/v1/providers/completed-cancelled-bookings';
      } else {
        // Fallback for any other status
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
          List<dynamic> dataList = [];

          // Handle different response structures
          if (status == 'completed' || status == 'cancelled') {
            // Response is wrapped as { "completed": [...], "cancelled": [...] }
            final responseMap = success.data as Map<String, dynamic>;
            dataList = (responseMap[status] as List<dynamic>?) ?? [];
          } else {
            // Response is a direct array
            dataList = success.data as List<dynamic>;
          }

          DPrint.log('✅ Bookings fetched: ${dataList.length} items');
          
          final bookings = dataList
              .map((item) => ProviderBooking.fromJson(item as Map<String, dynamic>))
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
}
