import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class NotificationSoundService {
  static final NotificationSoundService _instance = NotificationSoundService._internal();
  factory NotificationSoundService() => _instance;
  NotificationSoundService._internal();

  final AudioPlayer _player = AudioPlayer();

  static const String _soundAsset = 'sounds/notificationSound.mp3';

  Future<void> play() async {
    try {
      await _player.stop();
      await _player.play(AssetSource(_soundAsset));
    } catch (e) {
      if (kDebugMode) debugPrint('🔔 Sound play error: $e');
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
