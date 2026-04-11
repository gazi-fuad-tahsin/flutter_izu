import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chatbot_chat_screen.dart';

class ChatbotOverlayScreen extends StatelessWidget {
  const ChatbotOverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3), // Dark translucent overlay
      body: SafeArea(
        child: Stack(
          children: [
            // Click outside to dismiss
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Get.back(),
                behavior: HitTestBehavior.opaque,
                child: Container(),
              ),
            ),
            // The Search Prompt Box
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).size.height * 0.45, // roughly middle-lower as in Image 3
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search with AI',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onSubmitted: (value) {
                           Get.off(() => const ChatbotChatScreen());
                        },
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A84F8), // Blue mic
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.mic, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        // Navigate to actual chat screen
                        Get.off(() => const ChatbotChatScreen());
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5A84F8), // Blue send
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.send, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
