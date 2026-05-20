import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/call_controller.dart';

class IncomingCallOverlay extends StatelessWidget {
  const IncomingCallOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar
            Obx(() {
              final image = controller.remoteImage.value;
              return CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    image.startsWith('http') ? NetworkImage(image) : null,
                child: image.startsWith('http')
                    ? null
                    : const Icon(Icons.person, size: 40, color: Colors.grey),
              );
            }),
            const SizedBox(height: 16),

            // Name / label
            Obx(() => Text(
                  controller.remoteName.value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 6),
            Text(
              'Audio Call',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // Accept / Reject buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Reject
                _CallButton(
                  icon: Icons.call_end,
                  color: Colors.red,
                  label: 'Decline',
                  onTap: controller.rejectCall,
                ),

                // Accept
                _CallButton(
                  icon: Icons.call,
                  color: const Color(0xFF2870BC),
                  label: 'Accept',
                  onTap: controller.acceptCall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _CallButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
