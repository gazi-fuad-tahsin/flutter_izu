import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallService {
  static final CallService _instance = CallService._internal();
  factory CallService() => _instance;
  CallService._internal();

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  bool _remoteDescriptionSet = false;
  final List<RTCIceCandidate> _remoteIceCandidatesQueue = [];

  // Callbacks wired by CallController
  void Function(RTCIceCandidate)? onIceCandidate;
  void Function()? onCallConnected;
  void Function()? onCallDisconnected;

  static const Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
      // TURN relay — required for real devices behind strict NAT / different networks
      {
        'urls': 'turn:openrelay.metered.ca:80',
        'username': 'openrelayproject',
        'credential': 'openrelayproject',
      },
      {
        'urls': 'turn:openrelay.metered.ca:443',
        'username': 'openrelayproject',
        'credential': 'openrelayproject',
      },
      {
        'urls': 'turn:openrelay.metered.ca:443?transport=tcp',
        'username': 'openrelayproject',
        'credential': 'openrelayproject',
      },
    ],
    'sdpSemantics': 'unified-plan',
  };

  Future<void> _createPeerConnection() async {
    _peerConnection = await createPeerConnection(_iceServers);

    _peerConnection!.onIceCandidate = (candidate) {
      onIceCandidate?.call(candidate);
    };

    _peerConnection!.onConnectionState = (state) {
      if (kDebugMode) debugPrint('📡 PeerConnection state: $state');
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        onCallConnected?.call();
      } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
          state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        onCallDisconnected?.call();
      }
    };

    _peerConnection!.onIceConnectionState = (state) {
      if (kDebugMode) debugPrint('📡 ICE Connection state: $state');
      if (state == RTCIceConnectionState.RTCIceConnectionStateConnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateCompleted) {
        onCallConnected?.call();
      } else if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateFailed ||
          state == RTCIceConnectionState.RTCIceConnectionStateClosed) {
        onCallDisconnected?.call();
      }
    };

    _peerConnection!.onTrack = (event) {
      if (kDebugMode) {
        debugPrint('📡 Received remote track: ${event.track.kind}');
      }
      if (event.track.kind == 'audio') {
        event.track.enabled = true;
      }
    };

    _peerConnection!.onAddStream = (stream) {
      if (kDebugMode) {
        debugPrint('📡 Received remote stream: ${stream.id}');
      }
      for (final track in stream.getAudioTracks()) {
        track.enabled = true;
      }
    };
  }

  Future<void> _addLocalAudioTrack() async {
    if (!kIsWeb) {
      try {
        await Helper.setAppleAudioConfiguration(AppleAudioConfiguration(
          appleAudioCategory: AppleAudioCategory.playAndRecord,
          appleAudioCategoryOptions: {
            AppleAudioCategoryOption.defaultToSpeaker,
            AppleAudioCategoryOption.allowBluetooth,
          },
          appleAudioMode: AppleAudioMode.voiceChat,
        ));
      } catch (e) {
        if (kDebugMode) debugPrint('Error setting Apple audio config: $e');
      }

      try {
        await Helper.setAndroidAudioConfiguration(AndroidAudioConfiguration.communication);
      } catch (e) {
        if (kDebugMode) debugPrint('Error setting Android audio config: $e');
      }
    }

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });
    for (final track in _localStream!.getAudioTracks()) {
      await _peerConnection!.addTrack(track, _localStream!);
    }
  }

  /// Process any candidates that were queued before the remote description was set
  Future<void> _processQueuedIceCandidates() async {
    if (_peerConnection == null) return;
    if (kDebugMode) {
      debugPrint('📡 Processing ${_remoteIceCandidatesQueue.length} queued ICE candidates');
    }
    for (final candidate in _remoteIceCandidatesQueue) {
      try {
        await _peerConnection!.addCandidate(candidate);
      } catch (e) {
        if (kDebugMode) debugPrint('❌ Error adding queued ICE candidate: $e');
      }
    }
    _remoteIceCandidatesQueue.clear();
  }

  /// Called by the initiator — creates offer SDP
  Future<Map<String, dynamic>> createOffer() async {
    await _createPeerConnection();
    await _addLocalAudioTrack();
    final offer = await _peerConnection!.createOffer({'offerToReceiveAudio': 1});
    await _peerConnection!.setLocalDescription(offer);
    return {'sdp': offer.sdp, 'type': offer.type};
  }

  /// Called by the recipient — sets remote offer, creates answer SDP
  Future<Map<String, dynamic>> createAnswer(Map<String, dynamic> offerMap) async {
    await _createPeerConnection();
    await _addLocalAudioTrack();
    final offer = RTCSessionDescription(offerMap['sdp'], offerMap['type']);
    await _peerConnection!.setRemoteDescription(offer);
    _remoteDescriptionSet = true;
    await _processQueuedIceCandidates();

    final answer = await _peerConnection!.createAnswer({'offerToReceiveAudio': 1});
    await _peerConnection!.setLocalDescription(answer);
    return {'sdp': answer.sdp, 'type': answer.type};
  }

  /// Called by the initiator when it receives the answer
  Future<void> setRemoteAnswer(Map<String, dynamic> answerMap) async {
    final answer = RTCSessionDescription(answerMap['sdp'], answerMap['type']);
    await _peerConnection?.setRemoteDescription(answer);
    _remoteDescriptionSet = true;
    await _processQueuedIceCandidates();
  }

  /// Adds a trickled ICE candidate from the remote peer
  Future<void> addIceCandidate(Map<String, dynamic> candidateMap) async {
    final candidate = RTCIceCandidate(
      candidateMap['candidate'] as String?,
      candidateMap['sdpMid'] as String?,
      candidateMap['sdpMLineIndex'] as int?,
    );
    if (_peerConnection != null && _remoteDescriptionSet) {
      await _peerConnection!.addCandidate(candidate);
    } else {
      if (kDebugMode) debugPrint('📡 Queueing ICE candidate: ${candidate.candidate}');
      _remoteIceCandidatesQueue.add(candidate);
    }
  }

  /// Mutes/unmutes the local audio track
  void setMuted(bool muted) {
    _localStream?.getAudioTracks().forEach((t) => t.enabled = !muted);
  }

  /// Toggles the phone speaker
  Future<void> setSpeaker(bool on) async {
    try {
      await Helper.setSpeakerphoneOn(on);
    } catch (_) {}
  }

  /// Releases all resources
  Future<void> dispose() async {
    onIceCandidate = null;
    onCallConnected = null;
    onCallDisconnected = null;
    _remoteDescriptionSet = false;
    _remoteIceCandidatesQueue.clear();
    _localStream?.getTracks().forEach((t) => t.stop());
    await _localStream?.dispose();
    await _peerConnection?.close();
    _localStream = null;
    _peerConnection = null;
  }
}
