import 'package:flutter/material.dart';

import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../data/model/provider_booking_model.dart';
import '../widgets/provider_booking_card.dart';

class ProviderBookingScreen extends StatefulWidget {
  const ProviderBookingScreen({super.key});

  @override
  State<ProviderBookingScreen> createState() => _ProviderBookingScreenState();
}

class _ProviderBookingScreenState extends State<ProviderBookingScreen> {
  String _selectedFilter = 'live';

  // Sample booking data
  final Map<String, List<ProviderBooking>> bookingsByFilter = {
    'live': [
      ProviderBooking(
        id: '1',
        clientName: 'Mr. Raja',
        clientImage: 'assets/images/profile_avatar.png',
        location: '13th Street. 47 W 13th St, New York, NY 10011',
        date: '12 July 2025',
        time: '10:00 AM',
        service: 'House Cleaning',
        amount: '\$550',
        status: 'live',
        duration: '01h 60m 30s',
      ),
    ],
    'next': [
      ProviderBooking(
        id: '2',
        clientName: 'Priyanka Rs',
        clientImage: 'assets/images/profile_avatar.png',
        location: '13th Street. 47 W 13th St, New York, NY 10011',
        date: '12 July 2025',
        time: '10:00 AM',
        service: 'House Cleaning',
        amount: '\$550',
        status: 'next',
        paymentStatus: 'Pending',
      ),
      ProviderBooking(
        id: '3',
        clientName: 'Priyanka Rs',
        clientImage: 'assets/images/profile_avatar.png',
        location: '13th Street. 47 W 13th St, New York, NY 10011',
        date: '12 July 2025',
        time: '10:00 AM',
        service: 'House Cleaning',
        amount: '\$550',
        status: 'next',
        paymentStatus: 'Accepted',
      ),
    ],
    'completed': [
      ProviderBooking(
        id: '4',
        clientName: 'Priyanka Rs',
        clientImage: 'assets/images/profile_avatar.png',
        location: '13th Street. 47 W 13th St, New York, NY 10011',
        date: '12 July 2025',
        time: '10:00 AM',
        service: 'House Cleaning',
        amount: '\$550',
        status: 'completed',
      ),
      ProviderBooking(
        id: '5',
        clientName: 'Priyanka Rs',
        clientImage: 'assets/images/profile_avatar.png',
        location: '13th Street. 47 W 13th St, New York, NY 10011',
        date: '12 July 2025',
        time: '10:00 AM',
        service: 'House Cleaning',
        amount: '\$550',
        status: 'completed',
      ),
      ProviderBooking(
        id: '6',
        clientName: 'Priyanka Rs',
        clientImage: 'assets/images/profile_avatar.png',
        location: '13th Street. 47 W 13th St, New York, NY 10011',
        date: '12 July 2025',
        time: '10:00 AM',
        service: 'House Cleaning',
        amount: '\$550',
        status: 'completed',
      ),
    ],
    'cancelled': [
      ProviderBooking(
        id: '7',
        clientName: 'Priyanka Rs',
        clientImage: 'assets/images/profile_avatar.png',
        location: '13th Street. 47 W 13th St, New York, NY 10011',
        date: '12 July 2025',
        time: '10:00 AM',
        service: 'House Cleaning',
        amount: '\$550',
        status: 'cancelled',
        isCancelled: true,
      ),
      ProviderBooking(
        id: '8',
        clientName: 'Priyanka Rs',
        clientImage: 'assets/images/profile_avatar.png',
        location: '13th Street. 47 W 13th St, New York, NY 10011',
        date: '12 July 2025',
        time: '10:00 AM',
        service: 'House Cleaning',
        amount: '\$550',
        status: 'cancelled',
        isCancelled: true,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   // leading: IconButton(
      //   //   icon: const Icon(Icons.arrow_back, color: Colors.black),
      //   //   onPressed: () => Navigator.pop(context),
      //   // ),
      // ),
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
            child: bookingsByFilter[_selectedFilter]?.isEmpty ?? true
                ? Center(
                    child: Text(
                      'No ${_selectedFilter} bookings',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: bookingsByFilter[_selectedFilter]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final booking = bookingsByFilter[_selectedFilter]![index];
                      return ProviderBookingCard(
                        booking: booking,
                        filterType: _selectedFilter,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
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
  }
}
