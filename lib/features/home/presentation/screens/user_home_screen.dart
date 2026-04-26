import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/controller/user_controller.dart';
import '../../../booking/presentation/screens/booking_list_screen.dart';
import '../../../category/presentation/controller/category_controller.dart';
import '../../../category/presentation/screens/all_categories_screen.dart';
import '../../../chatbot/presentation/widgets/chatbot_overlay_popup.dart';
import '../../../message/presentation/screens/message_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../profile/presentation/screens/user_profile_screen.dart';
import '../../../service/presentation/controller/service_controller.dart';
import '../../../service/presentation/screens/services_list_screen.dart';
import '../controllers/home_controller.dart';
import '../widgets/categories_list.dart';
import '../widgets/featured_artisans_section.dart';
import '../widgets/home_header.dart';
import '../widgets/nearby_artisans_section.dart';
import '../widgets/provider_ready_dialog.dart';
import '../widgets/section_header.dart';
import '../widgets/super_deals_banner.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _currentIndex = 0;
  late HomeController _homeController;

  @override
  void initState() {
    super.initState();
    // Get or create HomeController
    if (Get.isRegistered<HomeController>()) {
      _homeController = Get.find<HomeController>();
    } else {
      _homeController = Get.put(HomeController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: Stack(
        children: [
          _currentIndex == 0
              ? _buildHomeContent()
              : _currentIndex == 1
                  ? const BookingListScreen()
                  : _currentIndex == 2
                      ? const MessageScreen()
                      : Scaffold(
                          backgroundColor: AppColors.primaryWhite,
                          body: Center(
                            child: Text(IzuHomeTexts.navMessage),
                          ),
                        ),
          // Listen for request-accepted event and show dialog
          Obx(() {
            final requestData = _homeController.requestAcceptedData.value;
            if (requestData != null && _homeController.showAcceptanceDialog.value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showProviderReadyDialog(requestData);
              });
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          border: Border(
            top: BorderSide(color: AppColors.updateGrey, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 3) {
              Get.to(() => const UserProfileScreen());
            } else {
              setState(() => _currentIndex = index);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.primaryWhite,
          selectedItemColor: AppColors.homePrimary,
          unselectedItemColor: AppColors.subText,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: IzuHomeTexts.navHome,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month),
              label: IzuHomeTexts.navBooking,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              activeIcon: Icon(Icons.message),
              label: IzuHomeTexts.navMessage,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: IzuHomeTexts.navProfile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with user greeting
                Obx(() {
                  final userController = Get.find<UserController>();
                  return HomeHeader(
                    userName: userController.userName,
                    greeting: 'Hi, Good Morning',
                    avatarAsset: userController.userProfileImage ?? 'assets/images/home_assets/profile.jpg',
                    onNotificationTap: () {
                      Get.to(() => const NotificationsScreen());
                    },
                  );
                }),
                const SizedBox(height: 24),

                // Super Deals Banner
                SuperDealsBanner(
                  onPressed: () {
                    Get.to(() => const ServicesListScreen(sourceScreen: 'super_deals'));
                  },
                ),
                const SizedBox(height: 24),

                // Categories Section
                SectionHeader(
                  title: IzuHomeTexts.selectCategory,
                  onViewAll: () {
                    Get.to(() => const AllCategoriesScreen());
                  },
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final categoryController = Get.find<CategoryController>();
                  final topCategories = categoryController.topFiveCategories;
                  
                  // Convert CategoryModel to Map format for CategoriesList widget
                  final categoriesList = topCategories.map((cat) {
                    return {
                      'name': cat.name,
                      'image': cat.catImage,
                    };
                  }).toList();
                  
                  return CategoriesList(
                    categories: categoriesList,
                    onCategoryTap: (index) {},
                  );
                }),
                const SizedBox(height: 24),

                // Featured Artisans Section
                SectionHeader(
                  title: IzuHomeTexts.featuredArtisans,
                  onViewAll: () {
                    Get.to(() => const ServicesListScreen(sourceScreen: 'featured'));
                  },
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final serviceController = Get.find<ServiceController>();
                  final featured = serviceController.featuredArtisans;
                  
                  final artisans = featured.map((svc) {
                    // Get service image - use first thumbnail if available
                    final serviceImage = svc.serviceDetails.serviceThumbnails.isNotEmpty
                        ? svc.serviceDetails.serviceThumbnails[0] as String
                        : 'assets/images/home_assets/artisan_1.jpg';
                    
                    return {
                      'bgImage': serviceImage,
                      'jobTitle': svc.category.name,
                      'profileImage': svc.provider.profileImage,
                      'name': svc.provider.name,
                      'username': '@Service Provider',
                      'rating': svc.averageRating.toStringAsFixed(1),
                      'distance': svc.serviceDetails.address,
                      'price': '${svc.serviceDetails.hourlyPrice}/hr',
                    };
                  }).toList();
                  
                  final serviceIds = featured.map((svc) => svc.id).toList();
                  
                  return FeaturedArtisansSection(
                    artisans: artisans,
                    serviceIds: serviceIds,
                    onArtisanTap: (index) {},
                  );
                }),
                const SizedBox(height: 24),

                // Nearby Artisans Section
                SectionHeader(
                  title: IzuHomeTexts.artisansNearBy,
                  onViewAll: () {
                    Get.to(() => const ServicesListScreen(sourceScreen: 'nearby'));
                  },
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final serviceController = Get.find<ServiceController>();
                  final nearby = serviceController.nearbyArtisans;
                  
                  final artisans = nearby.map((svc) {
                    // Get service image - use first thumbnail if available
                    final serviceImage = svc.serviceDetails.serviceThumbnails.isNotEmpty
                        ? svc.serviceDetails.serviceThumbnails[0] as String
                        : 'assets/images/home_assets/artisan_1.jpg';
                    
                    return {
                      'bgImage': serviceImage,
                      'jobTitle': svc.category.name,
                      'profileImage': svc.provider.profileImage,
                      'name': svc.provider.name,
                      'username': '@Service Provider',
                      'rating': svc.averageRating.toStringAsFixed(1),
                      'distance': svc.serviceDetails.address,
                      'price': '${svc.serviceDetails.hourlyPrice}/hr',
                    };
                  }).toList();
                  
                  final serviceIds = nearby.map((svc) => svc.id).toList();
                  
                  return NearbyArtisansSection(
                    artisans: artisans,
                    serviceIds: serviceIds,
                    onArtisanTap: (index) {},
                  );
                }),
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
                  color: AppColors.primaryWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.authBorderGrey, width: 1),
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
                    color: AppColors.homePrimary,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show provider ready confirmation dialog
  void _showProviderReadyDialog(Map<String, dynamic> requestData) {
    // Extract provider data from request
    final providerName = requestData['providerName'] ?? 'Provider';
    final providerImage = requestData['providerImage'] as String?;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProviderReadyConfirmationDialog(
        providerName: providerName,
        providerImage: providerImage,
        onAccept: () {
          _homeController.acceptProviderRequest();
        },
        onCancel: () {
          _homeController.cancelProviderRequest();
        },
      ),
    );
  }
}
