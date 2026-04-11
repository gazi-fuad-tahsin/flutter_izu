import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      {
        'isUser': true,
        'text': 'Hi, I need help booking an appointment.'
      },
      {
        'isUser': false,
        'text': 'Sure! What type of service are you looking for?'
      },
      {
        'isUser': false,
        'text': 'Please choose a date and time that works for you.'
      },
      {
        'isUser': true,
        'text': 'I want to book a haircut.\nTomorrow at 4 PM.'
      },
      {
        'isUser': false,
        'text': 'Perfect! Your appointment is available at 4:00 PM tomorrow.'
      },
    ];

    // Add initial message from popup if provided
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      _messages.add({
        'isUser': true,
        'text': widget.initialMessage,
      });
      // Add bot response
      _messages.add({
        'isUser': false,
        'text': 'I understand. How can I help you with that?'
      });
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
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Madiha Arora', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                Text('Hi, Good Morning', style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
            const Spacer(),
            Icon(Icons.notifications_none, color: Colors.grey.shade600),
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
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _msgController,
                        decoration: const InputDecoration(
                          hintText: 'Write here',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
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
                          // Add bot response
                          _messages.add({
                            'isUser': false,
                            'text': 'Thanks for that! Let me help you with your request.',
                          });
                        });
                        _scrollToBottom();
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A84F8),
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
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: const Icon(Icons.smart_toy, color: Color(0xFF5A84F8), size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF5A84F8) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
                boxShadow: [
                  if (!isUser) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFF2870BC),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 32), // spacer for symmetry if needed, or omit
          ]
        ],
      ),
    );
  }
}
