import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../category/presentation/screens/all_categories_screen.dart';
import '../../../chatbot/presentation/widgets/chatbot_overlay_popup.dart';
import '../../../profile/presentation/screens/user_profile_screen.dart';
import '../widgets/categories_list.dart';
import '../widgets/featured_artisans_section.dart';
import '../widgets/home_header.dart';
import '../widgets/nearby_artisans_section.dart';
import '../widgets/section_header.dart';
import '../widgets/super_deals_banner.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _currentIndex = 0;

  // Sample data
  final List<Map<String, String>> categories = [
    {'name': 'Cleaning', 'image': 'assets/images/home_assets/cat_cleaning.jpg'},
    {'name': 'Plumbing', 'image': 'assets/images/home_assets/cat_plumbing.jpg'},
    {'name': 'Electrical', 'image': 'assets/images/home_assets/cat_electrical.jpg'},
    {'name': 'Carpentry', 'image': 'assets/images/home_assets/cat_carpentry.jpg'},
  ];

  final List<Map<String, dynamic>> featuredArtisans = [
    {
      'bgImage': 'assets/images/home_assets/artisan_1.jpg',
      'category': 'Plumber',
      'profileImage': 'assets/images/home_assets/profile.jpg',
      'name': 'Mrs. Rani',
      'subtitle': '@Service Provider',
      'rating': '4.8',
      'distance': '2.5 km',
      'price': '45/hr',
    },
    {
      'bgImage': 'assets/images/home_assets/artisan_2.jpg',
      'category': 'Electrician',
      'profileImage': 'assets/images/home_assets/profile.jpg',
      'name': 'Mrs. Rani',
      'subtitle': '@Service Provider',
      'rating': '4.8',
      'distance': '2.5 km',
      'price': '45/hr',
    },
  ];

  final List<Map<String, dynamic>> nearbyArtisans = [
    {
      'bgImage': 'assets/images/home_assets/artisan_3.jpg',
      'category': 'Plumber',
      'profileImage': 'assets/images/home_assets/profile.jpg',
      'name': 'Mrs. Rani',
      'subtitle': '@Service Provider',
      'rating': '4.8',
      'distance': '2.5 km',
      'price': '45/hr',
    },
    {
      'bgImage': 'assets/images/home_assets/artisan_1.jpg',
      'category': 'Electrical',
      'profileImage': 'assets/images/home_assets/profile.jpg',
      'name': 'Mrs. Rani',
      'subtitle': '@Service Provider',
      'rating': '4.8',
      'distance': '2.5 km',
      'price': '45/hr',
    },
    {
      'bgImage': 'assets/images/home_assets/artisan_2.jpg',
      'category': 'Cleaning',
      'profileImage': 'assets/images/home_assets/profile.jpg',
      'name': 'Mrs. Rani',
      'subtitle': '@Service Provider',
      'rating': '4.8',
      'distance': '2.5 km',
      'price': '45/hr',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with user greeting
                  HomeHeader(
                    userName: 'Madiha Arora',
                    greeting: 'Hi, Good Morning',
                    avatarAsset: 'assets/images/home_assets/profile.jpg',
                    notificationCount: 3,
                    onNotificationTap: () {
                      // Handle notification tap
                    },
                  ),
                  const SizedBox(height: 24),

                  // Super Deals Banner
                  SuperDealsBanner(
                    onPressed: () {
                      // Handle All Services tap
                    },
                  ),
                  const SizedBox(height: 24),

                  // Categories Section
                  SectionHeader(
                    title: 'Select Category',
                    onViewAll: () {
                      Get.to(() => const AllCategoriesScreen());
                    },
                  ),
                  const SizedBox(height: 16),
                  CategoriesList(
                    categories: categories,
                    onCategoryTap: (index) {
                      // Handle category selection
                    },
                  ),
                  const SizedBox(height: 24),

                  // Featured Artisans Section
                  SectionHeader(
                    title: 'Featured Artisans',
                    onViewAll: () {
                      // Handle View all tap
                    },
                  ),
                  const SizedBox(height: 16),
                  FeaturedArtisansSection(
                    artisans: featuredArtisans,
                    onArtisanTap: (index) {
                      // Handle artisan selection
                    },
                  ),
                  const SizedBox(height: 24),

                  // Nearby Artisans Section
                  SectionHeader(
                    title: 'Artisans Near By you',
                    onViewAll: () {
                      // Handle View all tap
                    },
                  ),
                  const SizedBox(height: 16),
                  NearbyArtisansSection(
                    artisans: nearbyArtisans,
                    onArtisanTap: (index) {
                      // Handle artisan booking
                    },
                  ),
                ],
              ),
            ),

            // Floating AI Bot Icon
            Positioned(
              right: 20,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  showChatbotOverlayPopup(context);
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.smart_toy_outlined,
                      color: Color(0xFF2870BC),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 3) {
              // Navigate to Profile screen
              Get.to(() => const UserProfileScreen());
            } else {
              setState(() => _currentIndex = index);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2870BC),
          unselectedItemColor: Colors.grey.shade500,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              activeIcon: Icon(Icons.message),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
