import 'package:flutter/material.dart';

import 'featured_artisan_item.dart';

class FeaturedArtisansSection extends StatelessWidget {
  final List<Map<String, dynamic>> artisans;
  final Function(int)? onArtisanTap;

  const FeaturedArtisansSection({
    super.key,
    required this.artisans,
    this.onArtisanTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: artisans.isEmpty
              ? [
                  Center(
                    child: Text(
                      'No artisans available',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                ]
              : List.generate(
                  artisans.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index == artisans.length - 1 ? 0 : 16,
                    ),
                    child: FeaturedArtisanItem(
                      artisanData: artisans[index],
                      onViewPressed: () => onArtisanTap?.call(index),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
