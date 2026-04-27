import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/theme/app_colors.dart';
import 'chatbot_chat_screen.dart';

class ChatbotOverlayScreen extends StatelessWidget {
  const ChatbotOverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
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
              bottom: MediaQuery.of(context).size.height * 0.45,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
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
                        decoration: InputDecoration(
                          hintText: IzuChatbotTexts.searchWithAi,
                          border: InputBorder.none,
                          hintStyle: const TextStyle(color: AppColors.subText),
                        ),
                        onSubmitted: (value) {
                          Get.off(() => const ChatbotChatScreen());
                        },
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.chatbotBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.mic, color: AppColors.primaryWhite, size: 20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Get.off(() => const ChatbotChatScreen());
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.chatbotBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.send, color: AppColors.primaryWhite, size: 20),
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
