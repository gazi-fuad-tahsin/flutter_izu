import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../model/conversation_model.dart';
import '../model/message_model.dart';

class MessageRepository {
	final ApiClient _apiClient;
	final AuthStorageService _authStorageService;

	MessageRepository({
		ApiClient? apiClient,
		AuthStorageService? authStorageService,
	}) : _apiClient = apiClient ?? ApiClient(),
			 _authStorageService = authStorageService ?? AuthStorageService();

	Future<Either<NetworkFailure, List<Conversation>>> getConversations() async {
		try {
			final currentUserId = await _authStorageService.getUserId();

			final result = await _apiClient.get<Map<String, dynamic>>(
				'/api/v1/messages/',
				fromJsonT: (json) => json as Map<String, dynamic>,
			);

			return result.fold(
				(failure) => Left(failure),
				(success) {
					final response = success.data;
					final activeChats = (response['activeChats'] as List<dynamic>? ?? []);
					final nonActiveChats = (response['nonActiveChats'] as List<dynamic>? ?? []);

					final activeConversations = activeChats
							.whereType<Map<String, dynamic>>()
							.map((chat) => _mapChatToConversation(
										chat,
										currentUserId: currentUserId,
										isActive: true,
									))
							.toList();

					final nonActiveConversations = nonActiveChats
							.whereType<Map<String, dynamic>>()
							.map((chat) => _mapChatToConversation(
										chat,
										currentUserId: currentUserId,
										isActive: false,
									))
							.toList();

					final conversations = [
						...activeConversations,
						...nonActiveConversations,
					];

					conversations.sort(
						(a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
					);

					return Right(conversations);
				},
			);
		} catch (e) {
			return Left(
				UnknownFailure(message: 'Error fetching conversations: $e'),
			);
		}
	}

	Conversation _mapChatToConversation(
		Map<String, dynamic> chat, {
		required String? currentUserId,
		required bool isActive,
	}) {
		final participants = (chat['participants'] as List<dynamic>? ?? [])
				.whereType<Map<String, dynamic>>()
				.toList();

		Map<String, dynamic>? selectedParticipant;
		if (participants.isNotEmpty) {
			selectedParticipant = participants.firstWhere(
				(participant) => participant['_id']?.toString() != currentUserId,
				orElse: () => participants.first,
			);
		}

		final lastMessageMap = chat['lastMessage'] as Map<String, dynamic>?;
		final lastMessageContent = (lastMessageMap?['content'] as String?)?.trim();
		final lastMessageText =
				(lastMessageContent != null && lastMessageContent.isNotEmpty)
						? lastMessageContent
						: 'No messages yet';

		final lastMessageTimestampRaw =
				lastMessageMap?['createdAt'] ?? chat['updatedAt'] ?? chat['createdAt'];

		DateTime lastMessageTime;
		try {
			lastMessageTime = DateTime.parse(lastMessageTimestampRaw.toString());
		} catch (_) {
			lastMessageTime = DateTime.now();
		}

		final participantName =
				(selectedParticipant?['name'] as String?) ??
				(chat['title'] as String?) ??
				'Unknown User';

		final participantImage =
				(selectedParticipant?['profileImage'] as String?) ??
				(chat['imageUrl'] as String?) ??
				'assets/images/profile_image.png';

		final previewMessage = Message(
			id: (lastMessageMap?['_id'] as String?) ?? 'preview-${chat['_id']}',
			content: lastMessageText,
			timestamp: lastMessageTime,
			isFromUser: (lastMessageMap?['isMe'] as bool?) ?? false,
			attachments: _mapAttachments(lastMessageMap?['fileUrl']),
		);

		return Conversation(
			id: (chat['_id'] as String?) ?? '',
			userId: (selectedParticipant?['_id'] as String?) ?? '',
			userName: participantName,
			userImage: participantImage,
			lastMessage: lastMessageText,
			lastMessageTime: lastMessageTime,
			unreadCount: 0,
			messages: [previewMessage],
			isActive: isActive,
		);
	}

	Future<Either<NetworkFailure, List<Message>>> getChatMessages(
		String chatId,
	) async {
		try {
			final currentUserId = await _authStorageService.getUserId();

			final result = await _apiClient.get<List<dynamic>>(
				'/api/v1/messages/$chatId/messages',
				fromJsonT: (json) => json as List<dynamic>,
			);

			return result.fold(
				(failure) => Left(failure),
				(success) {
					final rawMessages = success.data;

					final messages = rawMessages
							.whereType<Map<String, dynamic>>()
							.map(
								(messageJson) => _mapMessage(
									messageJson,
									currentUserId: currentUserId,
								),
							)
							.toList();

					messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
					return Right(messages);
				},
			);
		} catch (e) {
			return Left(
				UnknownFailure(message: 'Error fetching chat messages: $e'),
			);
		}
	}

	Future<Either<NetworkFailure, Message>> sendMessage({
		required String chatId,
		required String content,
		required String contentType,
		String? filePath,
	}) async {
		try {
			final currentUserId = await _authStorageService.getUserId();

			final formData = FormData();
			formData.fields.add(MapEntry('chatId', chatId));
			formData.fields.add(MapEntry('content', content));
			formData.fields.add(MapEntry('contentType', contentType));

			if (filePath != null && filePath.isNotEmpty) {
				final fileName = filePath.split('/').last;
				final multipartFile = await MultipartFile.fromFile(
					filePath,
					filename: fileName,
				);
				formData.files.add(MapEntry('files', multipartFile));
			}

			final result = await _apiClient.postFormData<Map<String, dynamic>>(
				'/api/v1/messages/$chatId/message',
				formData: formData,
				fromJsonT: (json) => json as Map<String, dynamic>,
			);

			return result.fold(
				(failure) => Left(failure),
				(success) {
					final response = success.data;
					final messageJson = response['data'] is Map<String, dynamic>
							? response['data'] as Map<String, dynamic>
							: response;

					return Right(
						_mapMessage(
							messageJson,
							currentUserId: currentUserId,
							forceIsFromUser: true,
						),
					);
				},
			);
		} catch (e) {
			return Left(
				UnknownFailure(message: 'Error sending message: $e'),
			);
		}
	}

	Message _mapMessage(
		Map<String, dynamic> messageJson, {
		required String? currentUserId,
		bool? forceIsFromUser,
	}) {
		DateTime timestamp;
		try {
			timestamp = DateTime.parse(messageJson['createdAt'].toString());
		} catch (_) {
			timestamp = DateTime.now();
		}

		final isMe = messageJson['isMe'] as bool?;
		final senderMap = messageJson['sender'] as Map<String, dynamic>?;
		final senderId = senderMap?['_id']?.toString();
		final inferredIsFromUser = isMe ?? (senderId != null && senderId == currentUserId);

		return Message(
			id: messageJson['_id']?.toString() ?? DateTime.now().toString(),
			content: (messageJson['content'] as String?) ?? '',
			timestamp: timestamp,
			isFromUser: forceIsFromUser ?? inferredIsFromUser,
			attachments: _mapAttachments(messageJson['fileUrl']),
		);
	}

	List<MessageAttachment> _mapAttachments(dynamic rawAttachments) {
		if (rawAttachments is! List) {
			return const [];
		}

		return rawAttachments
				.whereType<Map<String, dynamic>>()
				.map(
					(attachment) => MessageAttachment(
						id: attachment['_id']?.toString() ?? attachment['url']?.toString() ?? '',
						name: (attachment['name'] as String?) ?? 'Attachment',
						contentType: (attachment['content'] as String?) ?? 'file',
						url: (attachment['url'] as String?) ?? '',
					),
				)
				.where((attachment) => attachment.url.isNotEmpty)
				.toList();
	}

	/// Create or get a conversation with a participant
	Future<Either<NetworkFailure, Conversation>> createConversation(
		String participantId,
	) async {
		try {
			final currentUserId = await _authStorageService.getUserId();

			final result = await _apiClient.post<Map<String, dynamic>>(
				'/api/v1/messages/create',
				data: {
					'participantId': participantId,
				},
				fromJsonT: (json) => json as Map<String, dynamic>,
			);

			return result.fold(
				(failure) => Left(failure),
				(success) {
					final response = success.data;
					final conversation = _mapChatToConversation(
						response,
						currentUserId: currentUserId,
						isActive: true,
					);
					return Right(conversation);
				},
			);
		} catch (e) {
			return Left(
				UnknownFailure(message: 'Error creating conversation: $e'),
			);
		}
	}
}
