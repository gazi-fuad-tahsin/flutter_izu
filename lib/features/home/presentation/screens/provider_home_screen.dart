import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/constants/texts.dart';
import 'package:intl/intl.dart';

import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../message/presentation/screens/message_screen.dart';
import '../../../notifications/presentation/controller/notification_controller.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../profile_provider/presentation/controller/provider_profile_controller.dart';
import '../../../profile_provider/presentation/screens/provider_profile_screen.dart';
import '../../../provider_jobs/presentation/screens/your_services_screen.dart';
import '../../data/model/service_request_model.dart';
import '../controllers/provider_home_controller.dart';
import '../widgets/request_card.dart';
import 'provider_booking_screen.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  int _selectedNavIndex = 0;
  late ProviderHomeController _controller;
  late ProviderProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ProviderHomeController());
    // Get or create ProviderProfileController
    if (Get.isRegistered<ProviderProfileController>()) {
      _profileController = Get.find<ProviderProfileController>();
    } else {
      _profileController = Get.put(ProviderProfileController());
    }
  }

  void _handleAccept(int index) {
    final request = _controller.pendingRequests[index];
    _controller.acceptRequest(request.id);
  }

  void _handleCancel(int index) {
    final request = _controller.pendingRequests[index];
    _controller.rejectRequest(request.id);
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

  String _formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('d MMMM yyyy').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  ServiceRequest _convertPendingRequestToServiceRequest(index) {
    final request = _controller.pendingRequests[index];
    return ServiceRequest(
      id: request.id,
      clientName: request.userId.name,
      clientImage: request.userId.profileImage,
      date: _formatDate(request.bookingTime),
      time: _formatTime(request.bookingTime),
      service: request.serviceId.serviceDetails?.title ?? 'Service',
      location: request.location.address,
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: IzuHomeTexts.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: IzuHomeTexts.navBooking,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.build),
            label: IzuHomeTexts.navService,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
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
          Obx(() {
            final providerData = _profileController.profileData.value;
            final isLoading = _profileController.isLoading.value;
            final profileImage = providerData?.profileImage ?? 'assets/images/profile_avatar.png';
            final providerName = providerData?.name ?? 'Provider';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey.shade500,
                                    ),
                                  ),
                                )
                              : _buildProviderAvatarImage(profileImage),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            providerName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '@${(providerData?.name ?? 'provider').toLowerCase().replaceAll(' ', '_')}',
                            style: const TextStyle(
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
                    onPressed: () {
                      Get.to(() => const MessageScreen());
                    },
                    icon: const Icon(Icons.message, color: Colors.black, size: 24),
                  ),
                  GetBuilder<NotificationController>(
                    init: NotificationController(),
                    builder: (notificationController) {
                      return IconButton(
                        onPressed: () {
                          Get.to(() => const NotificationsScreen());
                        },
                        icon: Obx(
                          () {
                            final unreadCount = notificationController.unreadCount;
                            return Stack(
                              children: [
                                const Icon(Icons.notifications, color: Colors.black, size: 24),
                                if (unreadCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),

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
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.homePrimary),
                  ),
                );
              }

              if (_controller.errorMessage.isNotEmpty) {
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
                        _controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _controller.fetchPendingRequests(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.homePrimary,
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

              if (_controller.pendingRequests.isEmpty) {
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
                        appTexts.noNotificationsYet.tr, // Or add "No requests yet"
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
                itemCount: _controller.pendingRequests.length,
                itemBuilder: (context, index) {
                  final serviceRequest = _convertPendingRequestToServiceRequest(index);
                  return RequestCard(
                    request: serviceRequest,
                    onAccept: () => _handleAccept(index),
                    onCancel: () => _handleCancel(index),
                  );
                },
              );
            }),
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

  /// Build provider avatar image handling both network and asset images
  Widget _buildProviderAvatarImage(String avatarImage) {
    // Check if avatarImage looks like a URL (network image)
    if (avatarImage.startsWith('http')) {
      return Image.network(
        avatarImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            color: Colors.grey.shade500,
            size: 28,
          );
        },
      );
    } else if (avatarImage.isNotEmpty) {
      // Asset image
      return Image.asset(
        avatarImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            color: Colors.grey.shade500,
            size: 28,
          );
        },
      );
    } else {
      // Fallback icon
      return Icon(
        Icons.person,
        color: Colors.grey.shade500,
        size: 28,
      );
    }
  }
}
