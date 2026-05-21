import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/widgets/app_skeleton.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/featured_artisan_item.dart';
import '../controller/service_controller.dart';
import 'service_details_screen.dart';

class ServicesListScreen extends StatefulWidget {
  final String? sourceScreen;

  const ServicesListScreen({
    super.key,
    this.sourceScreen,
  });

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  late ScrollController _categoryScrollController;

  @override
  void initState() {
    super.initState();
    _categoryScrollController = ScrollController();
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Services',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final serviceController = Get.find<ServiceController>();
        final categories = serviceController.categoryNames;

        if (categories.isEmpty) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(5, (_) => const ServiceListItemSkeleton()),
          );
        }

        return Column(
          children: [
            // Category Tabs (Horizontal Scroll)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SingleChildScrollView(
                controller: _categoryScrollController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: List.generate(categories.length, (index) {
                      final category = categories[index];
                      final isSelected = serviceController.selectedCategory == category;

                      return GestureDetector(
                        onTap: () {
                          serviceController.setSelectedCategory(category);
                          // Scroll to this tab if needed
                          _categoryScrollController.animateTo(
                            (index * 120.0), // Approximate width of each tab
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF2870BC) : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2870BC)
                                  : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Services List
            Expanded(
              child: Obx(() {
                final services = serviceController.selectedCategoryServices;

                if (services.isEmpty) {
                  return const Center(
                    child: Text(
                      'No services available',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    
                    // Get service image - use first thumbnail if available, otherwise placeholder
                    final serviceImageUrl = service.serviceDetails.serviceThumbnails.isNotEmpty
                        ? service.serviceDetails.serviceThumbnails[0] as String
                        : 'assets/images/home_assets/artisan_1.jpg';
                    
                    final artisanData = {
                      'bgImage': serviceImageUrl,
                      'jobTitle': service.category.name,
                      'profileImage': service.provider.profileImage,
                      'name': service.provider.name,
                      'username': '@Service Provider',
                      'rating': service.averageRating.toStringAsFixed(1),
                      'distance': service.serviceDetails.address,
                      'price': '${service.serviceDetails.hourlyPrice}/hr',
                    };

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: FeaturedArtisanItem(
                        artisanData: artisanData,
                        onViewPressed: () {
                          Get.to(() => ServiceDetailsScreen(serviceId: service.id));
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
