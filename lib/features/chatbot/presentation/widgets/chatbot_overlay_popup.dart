import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/chatbot_chat_screen.dart';

/// Chatbot Overlay Popup with blur background
/// Shows a search/input field positioned in the middle-lower area
class ChatbotOverlayPopup extends StatefulWidget {
  const ChatbotOverlayPopup({super.key});

  @override
  State<ChatbotOverlayPopup> createState() => _ChatbotOverlayPopupState();
}

class _ChatbotOverlayPopupState extends State<ChatbotOverlayPopup> {
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Navigate to chat screen with initial message
      Get.back();
      Get.to(
        () => ChatbotChatScreen(initialMessage: message),
        opaque: true,
        transition: Transition.rightToLeft,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Full background container with blue gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF5A84F8).withOpacity(0.4),
                  const Color(0xFF2870BC).withOpacity(1),
                ],
              ),
            ),
          ),
          // Blur filter on top
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF5A84F8).withOpacity(0.15),
                    const Color(0xFF2870BC).withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),
          // Click outside to dismiss
          GestureDetector(
            onTap: () => Get.back(),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Search input box positioned in middle-lower area
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).size.height * 0.35,
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping the box
              behavior: HitTestBehavior.opaque,
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
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Search with AI',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        style: const TextStyle(fontSize: 14),
                        onSubmitted: (_) => _handleSendMessage(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Microphone functionality (placeholder)
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF5A84F8),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.mic,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _handleSendMessage,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF5A84F8),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function to show chatbot overlay popup
void showChatbotOverlayPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => const ChatbotOverlayPopup(),
  );
}
