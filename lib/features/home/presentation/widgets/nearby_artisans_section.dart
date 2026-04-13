import 'package:flutter/material.dart';

import 'nearby_artisan_item.dart';

class NearbyArtisansSection extends StatelessWidget {
  final List<Map<String, dynamic>> artisans;
  final List<String>? serviceIds;
  final Function(int)? onArtisanTap;

  const NearbyArtisansSection({
    super.key,
    required this.artisans,
    this.serviceIds,
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
          serviceId: serviceIds != null && index < serviceIds!.length ? serviceIds![index] : null,
          onBookPressed: () => onArtisanTap?.call(index),
        );
      },
    );
  }
}
