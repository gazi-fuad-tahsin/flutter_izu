import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/conversation_model.dart';
import '../../data/repository/message_repository.dart';
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
  late MessageRepository _messageRepository;
  bool _isSearching = false;
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _messageRepository = MessageRepository();
    conversations = [];
    filteredConversations = conversations;
    _loadConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final result = await _messageRepository.getConversations();

    result.fold(
      (failure) {
        if (!mounted) return;
        setState(() {
          _error = failure.message;
          _isLoading = false;
        });
      },
      (data) {
        if (!mounted) return;
        setState(() {
          conversations = data;
          filteredConversations = data;
          _isLoading = false;
        });
      },
    );
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _error.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Error: $_error',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadConversations,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : filteredConversations.isEmpty
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
