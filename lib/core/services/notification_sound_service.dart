import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class NotificationSoundService {
  static final NotificationSoundService _instance = NotificationSoundService._internal();
  factory NotificationSoundService() => _instance;
  NotificationSoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _callPlayer = AudioPlayer();

  static const String _notifAsset = 'sounds/notificationSound.mp3';
  static const String _ringingAsset = 'sounds/ringingSound.mp3';
  static const String _callingAsset = 'sounds/callingSound.mp3';

  Future<void> play() async {
    try {
      await _player.stop();
      await _player.play(AssetSource(_notifAsset));
    } catch (e) {
      if (kDebugMode) debugPrint('🔔 Sound play error: $e');
    }
  }

  Future<void> playRinging() async {
    try {
      await _callPlayer.stop();
      await _callPlayer.setReleaseMode(ReleaseMode.loop);
      await _callPlayer.play(AssetSource(_ringingAsset));
    } catch (e) {
      if (kDebugMode) debugPrint('🔔 Ringing sound error: $e');
    }
  }

  Future<void> playCalling() async {
    try {
      await _callPlayer.stop();
      await _callPlayer.setReleaseMode(ReleaseMode.loop);
      await _callPlayer.play(AssetSource(_callingAsset));
    } catch (e) {
      if (kDebugMode) debugPrint('🔔 Calling sound error: $e');
    }
  }

  Future<void> stopCallSound() async {
    try {
      await _callPlayer.stop();
    } catch (e) {
      if (kDebugMode) debugPrint('🔔 Stop call sound error: $e');
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
    await _callPlayer.dispose();
  }
}
