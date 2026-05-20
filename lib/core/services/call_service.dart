import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallService {
  static final CallService _instance = CallService._internal();
  factory CallService() => _instance;
  CallService._internal();

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

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
  }

  Future<void> _addLocalAudioTrack() async {
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });
    for (final track in _localStream!.getAudioTracks()) {
      await _peerConnection!.addTrack(track, _localStream!);
    }
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
    final answer = await _peerConnection!.createAnswer({'offerToReceiveAudio': 1});
    await _peerConnection!.setLocalDescription(answer);
    return {'sdp': answer.sdp, 'type': answer.type};
  }

  /// Called by the initiator when it receives the answer
  Future<void> setRemoteAnswer(Map<String, dynamic> answerMap) async {
    final answer = RTCSessionDescription(answerMap['sdp'], answerMap['type']);
    await _peerConnection?.setRemoteDescription(answer);
  }

  /// Adds a trickled ICE candidate from the remote peer
  Future<void> addIceCandidate(Map<String, dynamic> candidateMap) async {
    final candidate = RTCIceCandidate(
      candidateMap['candidate'] as String?,
      candidateMap['sdpMid'] as String?,
      candidateMap['sdpMLineIndex'] as int?,
    );
    await _peerConnection?.addCandidate(candidate);
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
    _localStream?.getTracks().forEach((t) => t.stop());
    await _localStream?.dispose();
    await _peerConnection?.close();
    _localStream = null;
    _peerConnection = null;
  }
}
