import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/common/constants/feature_texts.dart';
import '../../../../../core/theme/app_colors.dart';

class ChatbotChatScreen extends StatefulWidget {
  final String? initialMessage;

  const ChatbotChatScreen({
    super.key,
    this.initialMessage,
  });

  @override
  State<ChatbotChatScreen> createState() => _ChatbotChatScreenState();
}

class _ChatbotChatScreenState extends State<ChatbotChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  late ScrollController _scrollController;
  late List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializeMessages();
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeMessages() {
    _messages = [
      {'isUser': true, 'text': IzuChatbotTexts.sampleUserMsg1},
      {'isUser': false, 'text': IzuChatbotTexts.sampleBotMsg1},
      {'isUser': false, 'text': IzuChatbotTexts.sampleBotMsg2},
      {'isUser': true, 'text': IzuChatbotTexts.sampleUserMsg2},
      {'isUser': false, 'text': IzuChatbotTexts.sampleBotMsg3},
    ];

    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      _messages.add({'isUser': true, 'text': widget.initialMessage});
      _messages.add({'isUser': false, 'text': IzuChatbotTexts.botUnderstandReply});
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.chatbotBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.subText,
              child: Icon(Icons.person, color: AppColors.primaryWhite, size: 16),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  IzuChatbotTexts.chatbotUserName,
                  style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  IzuChatbotTexts.chatbotGreeting,
                  style: const TextStyle(color: AppColors.subText, fontSize: 10),
                ),
              ],
            ),
            // const Spacer(),
            // const Icon(Icons.notifications_none, color: AppColors.subText),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildChatBubble(msg['text'], msg['isUser']);
                },
              ),
            ),
            // Bottom Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.primaryWhite,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.updateGrey,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _msgController,
                        decoration: InputDecoration(
                          hintText: IzuChatbotTexts.chatInputHint,
                          border: InputBorder.none,
                          hintStyle: const TextStyle(color: AppColors.subText),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      if (_msgController.text.trim().isNotEmpty) {
                        setState(() {
                          _messages.add({'isUser': true, 'text': _msgController.text});
                          _msgController.clear();
                          _messages.add({
                            'isUser': false,
                            'text': IzuChatbotTexts.botDefaultReply,
                          });
                        });
                        _scrollToBottom();
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
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
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.smart_toy, color: AppColors.chatbotBlue, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? AppColors.chatbotBlue : AppColors.primaryWhite,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
                boxShadow: [
                  if (!isUser)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? AppColors.primaryWhite : AppColors.homePrimary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 32),
          ],
        ],
      ),
    );
  }
}
