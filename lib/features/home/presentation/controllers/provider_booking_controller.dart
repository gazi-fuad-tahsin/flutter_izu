import 'package:get/get.dart';
import 'package:izu/core/utils/debug_print.dart';

import '../../data/model/provider_booking_model.dart';
import '../../data/repository/provider_booking_repository.dart';

class ProviderBookingController extends GetxController {
  final _repository = ProviderBookingRepository();

  final RxMap<String, List<ProviderBooking>> bookings =
      RxMap<String, List<ProviderBooking>>({
    'live': [],
    'next': [],
    'completed': [],
    'cancelled': [],
  });

  final RxBool isLoading = RxBool(false);
  final RxString errorMessage = RxString('');
  final RxString selectedFilter = RxString('live');

  @override
  void onInit() {
    super.onInit();
    fetchBookingsByStatus('live');
  }

  /// Fetch bookings for a specific status
  Future<void> fetchBookingsByStatus(String status) async {
    try {
      selectedFilter.value = status;
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log('📋 Fetching $status bookings...');

      final fetchedBookings = await _repository.getBookingsByStatus(status);
      
      // Sort live bookings so 'waiting-for-start' comes first
      if (status == 'live') {
        fetchedBookings.sort((a, b) {
          if (a.status == 'waiting-for-start' && b.status != 'waiting-for-start') {
            return -1;
          } else if (a.status != 'waiting-for-start' && b.status == 'waiting-for-start') {
            return 1;
          }
          return 0;
        });
      }
      
      bookings[status] = fetchedBookings;

      DPrint.log('✅ $status bookings fetched: ${fetchedBookings.length}');
    } catch (e) {
      DPrint.log('❌ Error fetching $status bookings: $e');
      errorMessage.value = 'Failed to load bookings';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all bookings for all statuses
  Future<void> fetchAllBookings() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log('📋 Fetching all bookings...');

      final liveBookings = await _repository.getBookingsByStatus('live');
      // Sort live bookings so 'waiting-for-start' comes first
      liveBookings.sort((a, b) {
        if (a.status == 'waiting-for-start' && b.status != 'waiting-for-start') {
          return -1;
        } else if (a.status != 'waiting-for-start' && b.status == 'waiting-for-start') {
          return 1;
        }
        return 0;
      });
      bookings['live'] = liveBookings;

      final nextBookings = await _repository.getBookingsByStatus('next');
      bookings['next'] = nextBookings;

      DPrint.log('✅ All bookings fetched successfully');

    } catch (e) {
      DPrint.log('❌ Error fetching all bookings: $e');
      errorMessage.value = 'Failed to load bookings';
    } finally {
      isLoading.value = false;
    }
  }

  /// Get bookings for current selected filter
  List<ProviderBooking> get currentFilteredBookings =>
      bookings[selectedFilter.value] ?? [];

  /// Refresh bookings for current filter
  Future<void> refreshCurrentFilter() async {
    await fetchBookingsByStatus(selectedFilter.value);
  }
}
