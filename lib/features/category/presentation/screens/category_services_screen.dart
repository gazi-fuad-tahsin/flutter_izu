import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  late List<Map<String, dynamic>> services;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _initializeServices() {
    // Sample services data - in production, this would come from API based on category
    final allServices = {
      'Cleaning': [
        {
          'title': 'Complete Kitchen Cleaning',
          'image': 'assets/images/home_assets/artisan_1.jpg',
          'providerName': 'Mrs. Rani',
          'providerSubtitle': '@Service Provider',
          'providerImage': 'assets/images/home_assets/profile.jpg',
          'rating': '4.8',
          'distance': '2.5 km',
          'price': '45/hr',
        },
        {
          'title': 'Complete Kitchen Cleaning',
          'image': 'assets/images/home_assets/artisan_2.jpg',
          'providerName': 'Mrs. Rani',
          'providerSubtitle': '@Service Provider',
          'providerImage': 'assets/images/home_assets/profile.jpg',
          'rating': '4.8',
          'distance': '2.5 km',
          'price': '45/hr',
        },
        {
          'title': 'Complete Kitchen Cleaning',
          'image': 'assets/images/home_assets/artisan_3.jpg',
          'providerName': 'Mrs. Rani',
          'providerSubtitle': '@Service Provider',
          'providerImage': 'assets/images/home_assets/profile.jpg',
          'rating': '4.8',
          'distance': '2.5 km',
          'price': '45/hr',
        },
      ],
      'Plumbing': [
        {
          'title': 'Pipe Installation & Repair',
          'image': 'assets/images/home_assets/artisan_1.jpg',
          'providerName': 'Mr. Singh',
          'providerSubtitle': '@Service Provider',
          'providerImage': 'assets/images/home_assets/profile.jpg',
          'rating': '4.9',
          'distance': '1.8 km',
          'price': '50/hr',
        },
        {
          'title': 'Leak Detection & Fixing',
          'image': 'assets/images/home_assets/artisan_2.jpg',
          'providerName': 'Mr. Singh',
          'providerSubtitle': '@Service Provider',
          'providerImage': 'assets/images/home_assets/profile.jpg',
          'rating': '4.9',
          'distance': '1.8 km',
          'price': '50/hr',
        },
      ],
      'Electrical': [
        {
          'title': 'Electrical Wiring & Installation',
          'image': 'assets/images/home_assets/artisan_3.jpg',
          'providerName': 'Mr. Sharma',
          'providerSubtitle': '@Service Provider',
          'providerImage': 'assets/images/home_assets/profile.jpg',
          'rating': '4.7',
          'distance': '3.0 km',
          'price': '60/hr',
        },
      ],
      'Carpentry': [
        {
          'title': 'Custom Furniture Making',
          'image': 'assets/images/home_assets/artisan_1.jpg',
          'providerName': 'Mr. Kumar',
          'providerSubtitle': '@Service Provider',
          'providerImage': 'assets/images/home_assets/profile.jpg',
          'rating': '4.8',
          'distance': '2.2 km',
          'price': '55/hr',
        },
      ],
      'Painting': [
        {
          'title': 'Interior & Exterior Painting',
          'image': 'assets/images/home_assets/artisan_2.jpg',
          'providerName': 'Mr. Verma',
          'providerSubtitle': '@Service Provider',
          'providerImage': 'assets/images/home_assets/profile.jpg',
          'rating': '4.6',
          'distance': '2.8 km',
          'price': '40/hr',
        },
      ],
      'Interior': [
        {
          'title': 'Interior Design & Decoration',
          'image': 'assets/images/home_assets/artisan_3.jpg',
          'providerName': 'Ms. Priya',
          'providerSubtitle': '@Service Provider',
          'providerImage': 'assets/images/home_assets/profile.jpg',
          'rating': '4.9',
          'distance': '1.5 km',
          'price': '65/hr',
        },
      ],
      'Construction': [
        {
          'title': 'Building Construction & Renovation',
          'image': 'assets/images/home_assets/artisan_1.jpg',
          'providerName': 'Mr. Patel',
          'providerSubtitle': '@Service Provider',
          'providerImage': 'assets/images/home_assets/profile.jpg',
          'rating': '4.8',
          'distance': '3.5 km',
          'price': '75/hr',
        },
      ],
    };

    services = allServices[widget.categoryName] ?? [];
  }

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
        child: services.isEmpty
            ? Center(
                child: Text(
                  'No services available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                child: Column(
                  children: List.generate(
                    services.length,
                    (index) {
                      final service = services[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: ServiceCard(
                          serviceTitle: service['title'],
                          serviceImage: service['image'],
                          categoryName: widget.categoryName,
                          providerName: service['providerName'],
                          providerSubtitle: service['providerSubtitle'],
                          providerImage: service['providerImage'],
                          rating: service['rating'],
                          distance: service['distance'],
                          price: service['price'],
                          onViewPressed: () {
                            // Handle service view
                            // Future: Navigate to service detail screen
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
