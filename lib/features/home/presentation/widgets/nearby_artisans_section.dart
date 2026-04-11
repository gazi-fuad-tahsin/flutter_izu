import 'package:flutter/material.dart';

import 'nearby_artisan_item.dart';

class NearbyArtisansSection extends StatelessWidget {
  final List<Map<String, dynamic>> artisans;
  final Function(int)? onArtisanTap;

  const NearbyArtisansSection({
    super.key,
    required this.artisans,
    this.onArtisanTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: artisans.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return NearbyArtisanItem(
          artisanData: artisans[index],
          onBookPressed: () => onArtisanTap?.call(index),
        );
      },
    );
  }
}
