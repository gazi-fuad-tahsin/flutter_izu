import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  late List<Conversation> filteredConversations;
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _initializeConversations();
    filteredConversations = conversations;
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
        userImage: 'assets/images/profile_image.png',
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
        userImage: 'assets/images/profile_image.png',
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
        userImage: 'assets/images/profile_image.png',
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
        userImage: 'assets/images/profile_image.png',
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
      if (value.isEmpty) {
        filteredConversations = conversations;
      } else {
        filteredConversations = conversations
            .where((conversation) =>
                conversation.userName.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        filteredConversations = conversations;
      }
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
                  // Left side: Back button + Greeting or Search
                  Expanded(
                    child: Row(
                      children: [
                        // Back button
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                        // User greeting (hidden when searching)
                        if (!_isSearching)
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
                        // Expanded search bar (shown when searching)
                        if (_isSearching)
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _onSearchChanged,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Search conversations...',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade400,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF2870BC),
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF2870BC),
                                  size: 20,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Right side: Search icon button
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2870BC),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _toggleSearch,
                      icon: Icon(
                        _isSearching ? Icons.close : Icons.search,
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
              child: filteredConversations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isSearching
                                ? 'No conversations found'
                                : 'No conversations',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredConversations.length,
                      itemBuilder: (context, index) {
                        final conversation = filteredConversations[index];
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
}
