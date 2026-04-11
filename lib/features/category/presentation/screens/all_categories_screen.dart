import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/category_grid_card.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  // Sample categories data
  final List<Map<String, String>> categories = [
    {
      'name': 'Cleaning',
      'image': 'assets/images/home_assets/cat_cleaning.jpg',
    },
    {
      'name': 'Plumbing',
      'image': 'assets/images/home_assets/cat_plumbing.jpg',
    },
    {
      'name': 'Electrical',
      'image': 'assets/images/home_assets/cat_electrical.jpg',
    },
    {
      'name': 'Carpentry',
      'image': 'assets/images/home_assets/cat_carpentry.jpg',
    },
    {
      'name': 'Painting',
      'image': 'assets/images/home_assets/cat_painting.jpg',
    },
    {
      'name': 'Interior',
      'image': 'assets/images/home_assets/cat_interior.jpg',
    },
    {
      'name': 'Construction',
      'image': 'assets/images/home_assets/cat_construction.jpg',
    },
  ];

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
        title: const Text(
          'All Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.95,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryGridCard(
                categoryName: category['name']!,
                imageAsset: category['image']!,
              );
            },
          ),
        ),
      ),
    );
  }
}
