import 'package:get/get.dart';

import '../../../../../core/base/base_controller.dart';
import '../../data/model/user_booking_model.dart';
import '../../data/repository/user_booking_repository.dart';

class UserBookingController extends BaseController {
  final _repository = UserBookingRepository();

  // State management
  final bookings = <String, RxList<UserBookingModel>>{
    'live': <UserBookingModel>[].obs,
    'upcoming': <UserBookingModel>[].obs,
    'completed': <UserBookingModel>[].obs,
    'cancelled': <UserBookingModel>[].obs,
  }.obs;

  final selectedFilter = 'live'.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  /// Fetch bookings by status
  Future<void> fetchBookingsByStatus(String status) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      update(); // Trigger UI update

      final fetchedBookings = await _repository.getBookingsByStatus(status);
      bookings[status]?.assignAll(fetchedBookings);
    } catch (e) {
      errorMessage.value = e.toString();
      bookings[status]?.clear();
    } finally {
      isLoading.value = false;
      update(); // Trigger UI update
    }
  }

  /// Refresh current filter's bookings
  Future<void> refreshCurrentFilter() async {
    await fetchBookingsByStatus(selectedFilter.value);
  }

  /// Get currently filtered bookings
  List<UserBookingModel> get currentFilteredBookings {
    return bookings[selectedFilter.value] ?? [];
  }

  /// Change selected filter and fetch bookings
  Future<void> selectFilter(String status) async {
    selectedFilter.value = status;
    update(); // Trigger UI update
    await fetchBookingsByStatus(status);
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch initial bookings for 'live' status
    fetchBookingsByStatus('live');
    update(); // Trigger initial UI update
  }
}
