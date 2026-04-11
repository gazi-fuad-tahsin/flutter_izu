import 'package:flutter/material.dart';

import 'category_card.dart';

class CategoriesList extends StatelessWidget {
  final List<Map<String, String>> categories;
  final Function(int)? onCategoryTap;

  const CategoriesList({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return CategoryCard(
            name: cat['name'] ?? '',
            image: cat['image'] ?? '',
            onTap: () => onCategoryTap?.call(index),
          );
        },
      ),
    );
  }
}
