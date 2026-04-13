import 'package:flutter/material.dart';

import '../../data/model/booking_model.dart';
import '../widgets/booking_card.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  String _selectedFilter = 'live';

  // Sample booking data - user's bookings with service providers
  final Map<String, List<UserBooking>> bookingsByFilter = {
    'live': [
      UserBooking(
        id: '1',
        providerName: 'John Smith',
        providerImage: 'assets/images/profile_avatar.png',
        location: '123 Main St, New York, NY 10001',
        date: '13 April 2025',
        time: '2:00 PM',
        service: 'House Cleaning',
        amount: '\$550',
        status: 'live',
        duration: '02h 15m 30s',
      ),
    ],
    'upcoming': [
      UserBooking(
        id: '2',
        providerName: 'Sarah Johnson',
        providerImage: 'assets/images/profile_avatar.png',
        location: '456 Oak Ave, Brooklyn, NY 11201',
        date: '15 April 2025',
        time: '10:00 AM',
        service: 'Plumbing',
        amount: '\$450',
        status: 'upcoming',
        paymentStatus: 'Pending',
      ),
      UserBooking(
        id: '3',
        providerName: 'Mike Davis',
        providerImage: 'assets/images/profile_avatar.png',
        location: '789 Pine Rd, Queens, NY 11375',
        date: '18 April 2025',
        time: '3:30 PM',
        service: 'Electrical Work',
        amount: '\$650',
        status: 'upcoming',
        paymentStatus: 'Accepted',
      ),
    ],
    'completed': [
      UserBooking(
        id: '4',
        providerName: 'Emma Wilson',
        providerImage: 'assets/images/profile_avatar.png',
        location: '321 Elm St, Manhattan, NY 10002',
        date: '10 April 2025',
        time: '9:00 AM',
        service: 'Painting',
        amount: '\$800',
        status: 'completed',
        rating: '4.8',
        review: 'Excellent work! Very professional and timely.',
      ),
      UserBooking(
        id: '5',
        providerName: 'John Brown',
        providerImage: 'assets/images/profile_avatar.png',
        location: '654 Maple Ln, Bronx, NY 10451',
        date: '8 April 2025',
        time: '1:00 PM',
        service: 'AC Repair',
        amount: '\$350',
        status: 'completed',
        rating: '4.5',
        review: 'Great service and very affordable.',
      ),
      UserBooking(
        id: '6',
        providerName: 'Lisa Anderson',
        providerImage: 'assets/images/profile_avatar.png',
        location: '987 Cedar Dr, Staten Island, NY 10301',
        date: '5 April 2025',
        time: '11:00 AM',
        service: 'Cleaning',
        amount: '\$200',
        status: 'completed',
        rating: '5.0',
        review: 'Perfect! Everything was clean and organized.',
      ),
    ],
    'cancelled': [
      UserBooking(
        id: '7',
        providerName: 'Robert Taylor',
        providerImage: 'assets/images/profile_avatar.png',
        location: '135 Birch Way, Queens, NY 11358',
        date: '2 April 2025',
        time: '4:00 PM',
        service: 'Landscaping',
        amount: '\$400',
        status: 'cancelled',
        isCancelled: true,
        cancelReason: 'Weather conditions prevented service completion',
      ),
      UserBooking(
        id: '8',
        providerName: 'Jennifer Garcia',
        providerImage: 'assets/images/profile_avatar.png',
        location: '246 Willow Ct, Brooklyn, NY 11204',
        date: '31 March 2025',
        time: '2:30 PM',
        service: 'Repairs',
        amount: '\$300',
        status: 'cancelled',
        isCancelled: true,
        cancelReason: 'Provider had emergency',
      ),
    ],
  };

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
                _buildFilterTab('Live', 'live'),
                const SizedBox(width: 12),
                _buildFilterTab('Upcoming', 'upcoming'),
                const SizedBox(width: 12),
                _buildFilterTab('Completed', 'completed'),
                const SizedBox(width: 12),
                _buildFilterTab('Cancelled', 'cancelled'),
              ],
            ),
          ),

          // Bookings List
          Expanded(
            child: bookingsByFilter[_selectedFilter]?.isEmpty ?? true
                ? Center(
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
                          'No ${_selectedFilter} bookings',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: bookingsByFilter[_selectedFilter]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final booking = bookingsByFilter[_selectedFilter]![index];
                      return BookingCard(
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
