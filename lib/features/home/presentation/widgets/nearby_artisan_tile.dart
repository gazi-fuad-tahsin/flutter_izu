import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/constants/texts.dart';

class NearbyArtisanTile extends StatelessWidget {
  final Map<String, dynamic> artisanData;

  const NearbyArtisanTile({super.key, required this.artisanData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFFDFF2FE), // Very light blue matching image background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Left image
          Stack(
            children: [
              Container(
                width: 130, // Proportional width
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                  image: DecorationImage(
                    image: AssetImage(artisanData['bgImage']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(artisanData['jobTitle'], style: const TextStyle(color: Color(0xFF2870BC), fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
          // Right Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 28, height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                                image: DecorationImage(image: AssetImage(artisanData['profileImage']), fit: BoxFit.cover)
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(artisanData['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis),
                                  Text(artisanData['username'], style: TextStyle(color: Colors.grey.shade600, fontSize: 9), overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 16),
                          Text(' ${artisanData['rating']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 12, color: Colors.grey.shade600),
                          Text(' ${artisanData['distance']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.attach_money, size: 12, color: Colors.grey.shade600),
                          Text('${artisanData['price']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2870BC),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text(appTexts.bookNow.tr, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
