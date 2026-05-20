import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:izu/core/network/services/socket_service.dart';

import '../../data/model/conversation_model.dart';
import '../controller/call_controller.dart';
import '../../data/model/message_model.dart';
import '../../data/repository/message_repository.dart';
import '../widgets/message_bubble.dart';

class MessageDetailScreen extends StatefulWidget {
  final Conversation conversation;

  const MessageDetailScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  late TextEditingController _messageController;
  late List<Message> _messages;
  final ImagePicker _imagePicker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  late MessageRepository _messageRepository;
  bool _isLoading = false;
  bool _isSending = false;
  String _error = '';
  String? _selectedFilePath;
  String? _selectedFileName;
  String _selectedContentType = 'text';
  Worker? _newMessageWorker;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messages = List.from(widget.conversation.messages);
    _messageRepository = MessageRepository();
    _loadMessages();
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    final socketService = Get.find<SocketService>();

    // Listen for messages sent by the other participant
    _newMessageWorker = ever(socketService.newMessage, (data) {
      if (data == null || !mounted) return;
      // Only handle messages for this conversation
      final chatId = Message.chatIdFromSocket(data);
      if (chatId != widget.conversation.id) return;
      // Skip if isMe — sender already sees it from the HTTP response
      final isMe = data['isMe'] as bool? ?? false;
      if (isMe) return;
      final incoming = Message.fromSocket(data);
      // Deduplicate by id
      if (_messages.any((m) => m.id == incoming.id)) return;
      setState(() => _messages.add(incoming));
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _newMessageWorker?.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDateHeader(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final result = await _messageRepository.getChatMessages(widget.conversation.id);

    result.fold(
      (failure) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _error = failure.message;
        });
      },
      (messages) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _messages = messages;
        });

        _scrollToBottom();
      },
    );
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty && _selectedFilePath == null) return;
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    final result = await _messageRepository.sendMessage(
      chatId: widget.conversation.id,
      content: content,
      contentType: _selectedFilePath == null ? 'text' : _selectedContentType,
      filePath: _selectedFilePath,
    );

    result.fold(
      (failure) {
        if (!mounted) return;
        setState(() {
          _isSending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (newMessage) {
        if (!mounted) return;
        setState(() {
          _messages.add(newMessage);
          _messageController.clear();
          _selectedFilePath = null;
          _selectedFileName = null;
          _selectedContentType = 'text';
          _isSending = false;
        });
        _scrollToBottom();
      },
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _pickFile() async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final PlatformFile file = result.files.first;
        if (file.path == null) return;

        final extension = file.extension?.toLowerCase() ?? '';
        final contentType = _contentTypeFromExtension(extension);
        setState(() {
          _selectedFilePath = file.path;
          _selectedFileName = file.name;
          _selectedContentType = contentType;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File selected: ${file.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error picking file'),
        ),
      );
    }
  }

  void _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedFilePath = pickedFile.path;
          _selectedFileName = pickedFile.name;
          _selectedContentType = 'image';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image selected: ${pickedFile.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error picking image'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.conversation.userName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.conversation.isActive ? 'Active now' : 'Offline',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.black),
            onPressed: () {
              Get.find<CallController>().initiateCall(
                toUserId: widget.conversation.userId,
                chatId: widget.conversation.id,
                toUserName: widget.conversation.userName,
                toUserImage: widget.conversation.userImage,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
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
                              onPressed: _loadMessages,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: _messages.length + _getDateHeaderCount(),
                        itemBuilder: (context, index) {
                          return _buildMessageItem(index);
                        },
                      ),
          ),
          // Message Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Attachment Button
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF2870BC),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.attach_file,
                      color: Color(0xFF2870BC),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Image Picker Button
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF2870BC),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.image,
                      color: Color(0xFF2870BC),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Message Input Field
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectedFileName != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Selected: $_selectedFileName',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedFilePath = null;
                                    _selectedFileName = null;
                                    _selectedContentType = 'text';
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Write your message',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade400,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: const Color(0xFF2870BC),
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
                        ),
                        minLines: 1,
                        maxLines: 3,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Send Button
                GestureDetector(
                  onTap: _isSending ? null : _sendMessage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF2870BC),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _isSending
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2870BC),
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: Color(0xFF2870BC),
                            size: 20,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _contentTypeFromExtension(String extension) {
    switch (extension) {
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'webp':
      case 'gif':
        return 'image';
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':
        return 'video';
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'm4a':
        return 'audio';
      default:
        return 'file';
    }
  }

  int _getDateHeaderCount() {
    if (_messages.isEmpty) return 0;
    int count = 1;
    for (int i = 1; i < _messages.length; i++) {
      if (_formatDateHeader(_messages[i].timestamp) !=
          _formatDateHeader(_messages[i - 1].timestamp)) {
        count++;
      }
    }
    return count;
  }

  Widget _buildMessageItem(int index) {
    int messageCount = 0;
    int dateHeaderCount = 0;

    for (int i = 0; i < _messages.length; i++) {
      if (i == 0 ||
          _formatDateHeader(_messages[i].timestamp) !=
              _formatDateHeader(_messages[i - 1].timestamp)) {
        if (dateHeaderCount == index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                _formatDateHeader(_messages[i].timestamp),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }
        dateHeaderCount++;
      }

      messageCount++;
      if (messageCount + dateHeaderCount == index + 1) {
        return MessageBubble(
          message: _messages[i],
          receiverAvatarUrl: widget.conversation.userImage,
        );
      }
    }

    return const SizedBox.shrink();
  }
}
