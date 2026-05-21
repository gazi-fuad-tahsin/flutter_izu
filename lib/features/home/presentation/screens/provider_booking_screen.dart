import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/common/widgets/app_skeleton.dart';
import '../../../../../core/theme/app_colors.dart';
import '../controllers/provider_booking_controller.dart';
import '../widgets/provider_booking_card.dart';

class ProviderBookingScreen extends StatefulWidget {
  const ProviderBookingScreen({super.key});

  @override
  State<ProviderBookingScreen> createState() => _ProviderBookingScreenState();
}

class _ProviderBookingScreenState extends State<ProviderBookingScreen> {
  late ProviderBookingController _controller;

  @override
  void initState() {
    super.initState();
    // Get or create ProviderBookingController
    if (Get.isRegistered<ProviderBookingController>()) {
      _controller = Get.find<ProviderBookingController>();
      // Re-mount: explicitly refresh the current filter
      _controller.refreshCurrentFilter();
    } else {
      // First mount: onInit handles the initial fetch
      _controller = Get.put(ProviderBookingController());
    }
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
            child: Row(
              children: [
                _buildFilterTab(ProviderBookingTexts.live, 'live'),
                const SizedBox(width: 12),
                _buildFilterTab(ProviderBookingTexts.next, 'next'),
                const SizedBox(width: 12),
                _buildFilterTab(ProviderBookingTexts.completed, 'completed'),
                const SizedBox(width: 12),
                _buildFilterTab(ProviderBookingTexts.cancelled, 'cancelled'),
              ],
            ),
          ),

          // Bookings List
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(3, (_) => const BookingCardSkeleton()),
                );
              }

              final currentBookings = _controller.currentFilteredBookings;

              if (currentBookings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No ${_controller.selectedFilter.value} bookings',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _controller.refreshCurrentFilter(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.homePrimary,
                        ),
                        child: const Text(
                          'Refresh',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                itemCount: currentBookings.length,
                itemBuilder: (context, index) {
                  final booking = currentBookings[index];
                  return ProviderBookingCard(
                    booking: booking,
                    filterType: _controller.selectedFilter.value,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, String value) {
    return Obx(() {
      final isSelected = _controller.selectedFilter.value == value;
      return GestureDetector(
        onTap: () {
          _controller.fetchBookingsByStatus(value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? ProviderColors.liveBlueFilled : Colors.white,
            border: Border.all(
              color: isSelected ? ProviderColors.liveBlueFilled : ProviderColors.nextOrangeOutline,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : ProviderColors.textBlack,
            ),
          ),
        ),
      );
    });
  }
}
