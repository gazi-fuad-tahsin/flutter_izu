import 'package:flutter/material.dart';

class FeaturedArtisanCard extends StatelessWidget {
  final Map<String, dynamic> artisanData;

  const FeaturedArtisanCard({super.key, required this.artisanData});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.55 > 250 ? 250 : screenWidth * 0.55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB5D7F8), width: 1.5), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Image & Badge container
          SizedBox(
            height: 115,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 105,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    image: DecorationImage(
                      image: AssetImage(artisanData['bgImage']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                    ),
                    child: Text(artisanData['jobTitle'], style: const TextStyle(color: Color(0xFF2870BC), fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Profile Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                              image: DecorationImage(image: AssetImage(artisanData['profileImage']), fit: BoxFit.cover)
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(artisanData['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                                Text(artisanData['username'], style: TextStyle(color: Colors.grey.shade600, fontSize: 9), overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 18),
                        Text(' ${artisanData['rating']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 14),
                // Meta info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                        Text(' ${artisanData['distance']}', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.attach_money, size: 14, color: Colors.grey.shade600),
                        Text('${artisanData['price']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Button
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2870BC),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('View', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
