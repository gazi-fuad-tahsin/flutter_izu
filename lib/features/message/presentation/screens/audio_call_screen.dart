import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/call_controller.dart';

class AudioCallScreen extends StatelessWidget {
  const AudioCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // Remote user info
            Obx(() {
              final image = controller.remoteImage.value;
              return Column(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.white24,
                    backgroundImage:
                        image.startsWith('http') ? NetworkImage(image) : null,
                    child: image.startsWith('http')
                        ? null
                        : const Icon(Icons.person,
                            size: 56, color: Colors.white54),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    controller.remoteName.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => _statusText(controller)),
                ],
              );
            }),

            const Spacer(),

            // Control buttons
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute
                  Obx(() => _ControlButton(
                        icon: controller.isMuted.value
                            ? Icons.mic_off
                            : Icons.mic,
                        label:
                            controller.isMuted.value ? 'Unmute' : 'Mute',
                        color: controller.isMuted.value
                            ? Colors.white
                            : Colors.white24,
                        iconColor: controller.isMuted.value
                            ? Colors.black87
                            : Colors.white,
                        onTap: controller.toggleMute,
                      )),

                  // End call
                  _ControlButton(
                    icon: Icons.call_end,
                    label: 'End',
                    color: Colors.red,
                    iconColor: Colors.white,
                    size: 72,
                    onTap: controller.endCall,
                  ),

                  // Speaker
                  Obx(() => _ControlButton(
                        icon: controller.isSpeakerOn.value
                            ? Icons.volume_up
                            : Icons.volume_off,
                        label: controller.isSpeakerOn.value
                            ? 'Speaker'
                            : 'Earpiece',
                        color: controller.isSpeakerOn.value
                            ? Colors.white
                            : Colors.white24,
                        iconColor: controller.isSpeakerOn.value
                            ? Colors.black87
                            : Colors.white,
                        onTap: controller.toggleSpeaker,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusText(CallController controller) {
    switch (controller.callState.value) {
      case CallState.outgoing:
        return const Text('Calling…',
            style: TextStyle(color: Colors.white70, fontSize: 16));
      case CallState.incoming:
        return const Text('Connecting…',
            style: TextStyle(color: Colors.white70, fontSize: 16));
      case CallState.active:
        return Text(
          controller.formattedDuration,
          style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final double size;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    required this.onTap,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: size * 0.45),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
