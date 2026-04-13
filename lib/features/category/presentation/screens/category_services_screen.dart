import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../service/presentation/controller/service_controller.dart';
import '../../../service/presentation/screens/service_details_screen.dart';
import '../widgets/service_card.dart';

class CategoryServicesScreen extends StatefulWidget {
  final String categoryName;

  const CategoryServicesScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<CategoryServicesScreen> createState() => _CategoryServicesScreenState();
}

class _CategoryServicesScreenState extends State<CategoryServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '${widget.categoryName} Services',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Obx(() {
          final serviceController = Get.find<ServiceController>();
          final services = serviceController.allServices[widget.categoryName] ?? [];

          if (services.isEmpty) {
            return Center(
              child: Text(
                'No services available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            child: Column(
              children: List.generate(
                services.length,
                (index) {
                  final service = services[index];
                  
                  // Get service image - use first thumbnail if available, otherwise placeholder
                  final serviceImageUrl = service.serviceDetails.serviceThumbnails.isNotEmpty
                      ? service.serviceDetails.serviceThumbnails[0] as String
                      : 'assets/images/home_assets/artisan_1.jpg';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: ServiceCard(
                      serviceTitle: service.serviceDetails.title,
                      serviceImage: serviceImageUrl,
                      categoryName: widget.categoryName,
                      providerName: service.provider.name,
                      providerSubtitle: '@Service Provider',
                      providerImage: service.provider.profileImage,
                      rating: service.averageRating.toStringAsFixed(1),
                      distance: service.serviceDetails.address,
                      price: '${service.serviceDetails.hourlyPrice}/hr',
                      onViewPressed: () {
                        Get.to(() => ServiceDetailsScreen(serviceId: service.id));
                      },
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
