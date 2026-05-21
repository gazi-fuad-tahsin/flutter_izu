import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:izu/core/network/services/socket_service.dart';
import 'package:izu/core/services/call_service.dart';
import 'package:izu/core/utils/debug_print.dart';

import '../screens/audio_call_screen.dart';
import '../widgets/incoming_call_overlay.dart';

enum CallState { idle, outgoing, incoming, active }

class CallController extends GetxController {
  final _callService = CallService();

  final Rx<CallState> callState = CallState.idle.obs;
  final RxString remoteUserId = ''.obs;
  final RxString remoteName = ''.obs;
  final RxString remoteImage = ''.obs;
  final RxString activeChatId = ''.obs;
  final RxBool isMuted = false.obs;
  final RxBool isSpeakerOn = false.obs;
  final RxInt callDurationSeconds = 0.obs;
  final RxBool isDialogShown = false.obs;

  Map<String, dynamic>? _pendingOffer;
  Timer? _callTimer;

  SocketService get _socket => Get.find<SocketService>();

  @override
  void onInit() {
    super.onInit();
    _listenToCallEvents();
  }

  // ─── Socket event listeners ───────────────────────────────────────────────

  void _listenToCallEvents() {
    ever(_socket.callIncoming, _onCallIncoming);
    ever(_socket.callAnswered, _onCallAnswered);
    ever(_socket.callIceCandidate, _onCallIceCandidate);
    ever(_socket.callRejected, _onCallRejected);
    ever(_socket.callEnded, _onCallEnded);
  }

  void _onCallIncoming(Map<String, dynamic>? data) {
    if (data == null || callState.value != CallState.idle) return;
    remoteUserId.value = data['from']?.toString() ?? '';
    activeChatId.value = data['chatId']?.toString() ?? '';
    remoteName.value = 'Incoming Call';
    remoteImage.value = '';

    final offerRaw = data['offer'];
    _pendingOffer = offerRaw is Map ? Map<String, dynamic>.from(offerRaw) : null;

    callState.value = CallState.incoming;
    if (!isDialogShown.value) {
      isDialogShown.value = true;
      Get.dialog(const IncomingCallOverlay(), barrierDismissible: false);
    }
  }

  void _onCallAnswered(Map<String, dynamic>? data) async {
    if (data == null) return;
    final answerRaw = data['answer'];
    if (answerRaw is Map) {
      await _callService.setRemoteAnswer(Map<String, dynamic>.from(answerRaw));
    }
    callState.value = CallState.active;
    _startTimer();
    _callService.setSpeaker(isSpeakerOn.value);
    DPrint.log('✅ Call connected');
  }

  void _onCallIceCandidate(Map<String, dynamic>? data) async {
    if (data == null) return;
    final candidateRaw = data['candidate'];
    if (candidateRaw is Map) {
      await _callService.addIceCandidate(Map<String, dynamic>.from(candidateRaw));
    }
  }

  void _onCallRejected(Map<String, dynamic>? data) {
    if (data == null) return;
    _cleanup();
    _safeBack();
    Get.snackbar('Call Rejected', '${remoteName.value} rejected the call',
        duration: const Duration(seconds: 3));
  }

  void _onCallEnded(Map<String, dynamic>? data) {
    if (data == null) return;
    _cleanup();
    _safeBack();
  }

  // ─── Public actions ────────────────────────────────────────────────────────

  /// Initiate a call — called from MessageDetailScreen
  Future<void> initiateCall({
    required String toUserId,
    required String chatId,
    required String toUserName,
    required String toUserImage,
  }) async {
    if (callState.value != CallState.idle) return;
    try {
      remoteUserId.value = toUserId;
      activeChatId.value = chatId;
      remoteName.value = toUserName;
      remoteImage.value = toUserImage;
      callState.value = CallState.outgoing;

      _callService.onIceCandidate = _sendIceCandidate;
      _callService.onCallConnected = () {
        callState.value = CallState.active;
        _startTimer();
        _callService.setSpeaker(isSpeakerOn.value);
      };

      final offer = await _callService.createOffer();
      _socket.emit('call:initiate', {
        'to': toUserId,
        'from': _socket.currentUserId,
        'chatId': chatId,
        'offer': offer,
      });

      Get.to(() => const AudioCallScreen());
    } catch (e) {
      DPrint.error('❌ Call initiation failed: $e');
      _cleanup();
    }
  }

  /// Accept the incoming call
  Future<void> acceptCall() async {
    isDialogShown.value = false;
    Get.back(); // close incoming overlay

    try {
      _callService.onIceCandidate = _sendIceCandidate;
      _callService.onCallConnected = () {
        callState.value = CallState.active;
        _startTimer();
        _callService.setSpeaker(isSpeakerOn.value);
      };

      if (_pendingOffer == null) return;
      final answer = await _callService.createAnswer(_pendingOffer!);
      _socket.emit('call:answer', {
        'to': remoteUserId.value,
        'from': _socket.currentUserId,
        'answer': answer,
      });

      callState.value = CallState.active;
      _startTimer();
      _callService.setSpeaker(isSpeakerOn.value);
      Get.to(() => const AudioCallScreen());
    } catch (e) {
      DPrint.error('❌ Accept call failed: $e');
      _cleanup();
    }
  }

  /// Reject the incoming call
  void rejectCall() {
    _socket.emit('call:reject', {
      'to': remoteUserId.value,
      'from': _socket.currentUserId,
    });
    isDialogShown.value = false;
    _cleanup();
    Get.back();
  }

  /// End the active / outgoing call
  Future<void> endCall() async {
    _socket.emit('call:end', {
      'to': remoteUserId.value,
      'from': _socket.currentUserId,
    });
    _cleanup();
    _safeBack();
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    _callService.setMuted(isMuted.value);
  }

  void toggleSpeaker() {
    isSpeakerOn.value = !isSpeakerOn.value;
    _callService.setSpeaker(isSpeakerOn.value);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void _sendIceCandidate(RTCIceCandidate candidate) {
    _socket.emit('call:ice-candidate', {
      'to': remoteUserId.value,
      'candidate': {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      },
    });
  }

  void _startTimer() {
    if (_callTimer != null && _callTimer!.isActive) return;
    _callTimer?.cancel();
    callDurationSeconds.value = 0;
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      callDurationSeconds.value++;
    });
  }

  void _cleanup() {
    _callTimer?.cancel();
    callDurationSeconds.value = 0;
    _pendingOffer = null;
    _callService.dispose();
    isMuted.value = false;
    isSpeakerOn.value = false;
    callState.value = CallState.idle;
    isDialogShown.value = false;
  }

  void _safeBack() {
    if (Get.currentRoute != '/') {
      Get.back();
    }
  }

  String get formattedDuration {
    final m = callDurationSeconds.value ~/ 60;
    final s = callDurationSeconds.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _callTimer?.cancel();
    _callService.dispose();
    super.onClose();
  }
}
