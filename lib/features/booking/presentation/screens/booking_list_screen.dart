import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/constants/texts.dart';

import '../controller/user_booking_controller.dart';
import '../widgets/user_booking_card.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize controller
    Get.put(UserBookingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),
          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: GetBuilder<UserBookingController>(
              builder: (controller) {
                return Row(
                  children: [
                    _buildFilterTab(appTexts.live.tr, 'live', controller),
                    const SizedBox(width: 12),
                    _buildFilterTab(appTexts.upcoming.tr, 'upcoming', controller),
                    const SizedBox(width: 12),
                    _buildFilterTab(appTexts.completed.tr, 'completed', controller),
                    const SizedBox(width: 12),
                    _buildFilterTab(appTexts.cancelled.tr, 'cancelled', controller),
                  ],
                );
              },
            ),
          ),

          // Bookings List
          Expanded(
            child: GetBuilder<UserBookingController>(
              builder: (controller) {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2870BC)),
                    ),
                  );
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => controller.refreshCurrentFilter(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2870BC),
                          ),
                          child: Text(
                            appTexts.retry.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final bookings = controller.currentFilteredBookings;

                if (bookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${appTexts.noBookingsYet.tr} (${controller.selectedFilter.value})',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return UserBookingCard(
                      booking: booking,
                      filterType: controller.selectedFilter.value,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, String value, UserBookingController controller) {
    final isSelected = controller.selectedFilter.value == value;
    return GestureDetector(
      onTap: () {
        controller.selectFilter(value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2870BC) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF2870BC) : const Color(0xFFFCA048),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF000000),
          ),
        ),
      ),
    );
  }
}
