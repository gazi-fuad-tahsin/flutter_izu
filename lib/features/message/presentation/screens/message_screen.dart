import 'package:flutter/material.dart';

import '../../data/model/conversation_model.dart';
import '../../data/model/message_model.dart';
import '../widgets/conversation_tile.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late List<Conversation> conversations;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _initializeConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeConversations() {
    conversations = [
      Conversation(
        id: '1',
        userId: 'user_alex_1',
        userName: 'Alex Linderson',
        userImage: 'assets/images/profile_avatar.png',
        lastMessage: 'How are you today?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 2)),
        unreadCount: 1,
        messages: [
          Message(
            id: '1',
            content: 'Hey! How are you?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
            isFromUser: false,
          ),
          Message(
            id: '2',
            content: 'I am good, thanks!',
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            isFromUser: true,
          ),
          Message(
            id: '3',
            content: 'How are you today?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
            isFromUser: false,
          ),
        ],
        isActive: true,
      ),
      Conversation(
        id: '2',
        userId: 'user_alex_2',
        userName: 'Alex Linderson',
        userImage: 'assets/images/profile_avatar.png',
        lastMessage: 'How are you today?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 2)),
        unreadCount: 1,
        messages: [
          Message(
            id: '4',
            content: 'Hey again!',
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            isFromUser: false,
          ),
          Message(
            id: '5',
            content: 'How are you today?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
            isFromUser: false,
          ),
        ],
        isActive: true,
      ),
      Conversation(
        id: '3',
        userId: 'user_john',
        userName: 'John Smith',
        userImage: 'assets/images/profile_avatar.png',
        lastMessage: 'Looking forward to it!',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 0,
        messages: [
          Message(
            id: '6',
            content: 'Are you coming tomorrow?',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            isFromUser: false,
          ),
          Message(
            id: '7',
            content: 'Yes, I will be there!',
            timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
            isFromUser: true,
          ),
          Message(
            id: '8',
            content: 'Looking forward to it!',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            isFromUser: false,
          ),
        ],
        isActive: false,
      ),
      Conversation(
        id: '4',
        userId: 'user_sarah',
        userName: 'Sarah Johnson',
        userImage: 'assets/images/profile_avatar.png',
        lastMessage: 'Thank you so much!',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        messages: [
          Message(
            id: '9',
            content: 'Thanks for your help',
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
            isFromUser: false,
          ),
          Message(
            id: '10',
            content: 'Anytime!',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            isFromUser: true,
          ),
          Message(
            id: '11',
            content: 'Thank you so much!',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            isFromUser: false,
          ),
        ],
        isActive: false,
      ),
    ];
  }

  void _onSearchChanged(String value) {
    setState(() {
      // Search functionality can be implemented here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with greeting and search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User greeting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Messages',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hi, Good Morning',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  // Search icon button
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2870BC),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        _showSearchDialog();
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Conversations List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];
                  return ConversationTile(
                    conversation: conversation,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Messages'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search conversations...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _onSearchChanged(_searchController.text);
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}
