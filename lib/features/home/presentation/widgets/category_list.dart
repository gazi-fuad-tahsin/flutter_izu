import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  CategoryList({super.key});

  final List<Map<String, String>> categories = [
    {'name': 'Cleaning', 'image': 'assets/images/home_assets/cat_cleaning.jpg'},
    {'name': 'Plumbing', 'image': 'assets/images/home_assets/cat_plumbing.jpg'},
    {'name': 'Electrical', 'image': 'assets/images/home_assets/cat_electrical.jpg'},
    {'name': 'Carpentry', 'image': 'assets/images/home_assets/cat_carpentry.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Column(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                  image: DecorationImage(
                    image: AssetImage(cat['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(child: Text(cat['name']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87))),
            ],
          );
        },
      ),
    );
  }
}
