// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';

// /// A singleton service that handles all app sound effects.
// /// Registered permanently so it's available from anywhere via Get.find().
// class SoundService extends GetxService {
//   final AudioPlayer _player = AudioPlayer();

//   @override
//   void onInit() {
//     super.onInit();
//     // Ensure the player never loops — play once and stop.
//     _player.setReleaseMode(ReleaseMode.stop);
//   }

//   @override
//   void onClose() {
//     _player.dispose();
//     super.onClose();
//   }

//   /// Plays the login success sound once.
//   Future<void> playLoginSound() =>
//       _playAsset('sounds/goingOnlineAndLoginSound.mp3');

//   /// Plays the logout/offline sound once.
//   Future<void> playLogoutSound() =>
//       _playAsset('sounds/notificationAndGoOffline.mp3');

//   /// Plays the notification sound for socket events, bottom sheets, dialogs, etc.
//   Future<void> playNotificationSound() =>
//       _playAsset('sounds/notificationAndGoOffline.mp3');

//   /// Plays the provider-side online/order sound.
//   Future<void> playOrderSound() =>
//       _playAsset('sounds/goingOnlineAndLoginSound.mp3');

//   Future<void> _playAsset(String assetPath) async {
//     try {
//       // Stop any currently playing sound before starting a new one.
//       await _player.stop();
//       await _player.setVolume(1.0);
//       await _player.play(AssetSource(assetPath));
//     } catch (e) {
//       debugPrint('🔇 SoundService error: $e');
//     }
//   }
// }
