import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../profile_provider/presentation/screens/provider_profile_screen.dart';
import '../../../provider_jobs/presentation/screens/your_services_screen.dart';
import '../../data/model/service_request_model.dart';
import '../widgets/request_card.dart';
import 'provider_booking_screen.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  int _selectedNavIndex = 0;

  // Sample data — TODO: replace with real data from controller/repository
  final List<ServiceRequest> requests = [
    ServiceRequest(
      id: '1',
      clientName: 'Mr. Raja',
      clientImage: 'assets/images/profile_avatar.png',
      date: '12 July 2025',
      time: '10:00 AM',
      service: 'House Cleaning',
      location: '13th Street. 47 W 13th St, New York, NY 10011',
    ),
    ServiceRequest(
      id: '2',
      clientName: 'Mr. Raja',
      clientImage: 'assets/images/profile_avatar.png',
      date: '12 July 2025',
      time: '10:00 AM',
      service: 'House Cleaning',
      location: '13th Street. 47 W 13th St, New York, NY 10011',
    ),
  ];

  void _handleAccept(int index) {
    Get.snackbar(
      IzuHomeTexts.successLabel,
      IzuHomeTexts.requestAccepted,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.successGreen,
      colorText: AppColors.primaryWhite,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleCancel(int index) {
    Get.snackbar(
      IzuHomeTexts.cancelledLabel,
      IzuHomeTexts.requestCancelled,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.cancelOrange,
      colorText: AppColors.primaryWhite,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: _selectedNavIndex == 0
          ? _buildHomeScreen()
          : _selectedNavIndex == 1
              ? const ProviderBookingScreen()
              : _selectedNavIndex == 2
                  ? _buildServiceScreen()
                  : _buildProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primaryWhite,
        selectedItemColor: AppColors.homePrimary,
        unselectedItemColor: AppColors.subText,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: IzuHomeTexts.navHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: IzuHomeTexts.navBooking,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: IzuHomeTexts.navService,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: IzuHomeTexts.navProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('assets/images/profile_avatar.png'),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ProviderProfileTexts.providerName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          ProviderProfileTexts.providerHandle,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.subText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message, color: Colors.black, size: 24),
                ),
                IconButton(
                  onPressed: () {
                    Get.to(() => const NotificationsScreen());
                  },
                  icon: const Icon(Icons.notifications, color: Colors.black, size: 24),
                ),
              ],
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                IzuHomeTexts.listOfRequests,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // Requests List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return RequestCard(
                  request: requests[index],
                  onAccept: () => _handleAccept(index),
                  onCancel: () => _handleCancel(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceScreen() {
    return const YourServicesScreen();
  }

  Widget _buildProfileScreen() {
    return const ProviderProfileScreen();
  }
}
