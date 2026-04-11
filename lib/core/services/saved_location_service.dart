// import 'package:get/get.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// /// Service to save and retrieve user's last known location
// class SavedLocationService extends GetxService {
//   static const String _boxName = 'saved_location';
//   static const String _locationKey = 'user_location';
  
//   Box? _box;

//   Future<SavedLocationService> init() async {
//     try {
//       _box = await Hive.openBox(_boxName);
//     } catch (e) {
//       print('Error opening saved location box: $e');
//     }
//     return this;
//   }

//   /// Save user's current location
//   Future<void> saveLocation(LocationModel location) async {
//     try {
//       await _box?.put(_locationKey, {
//         'latitude': location.latitude,
//         'longitude': location.longitude,
//         'address': location.address,
//         'placeName': location.placeName,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//       });
//       print('✅ Location saved: ${location.placeName}');
//     } catch (e) {
//       print('❌ Error saving location: $e');
//     }
//   }

//   /// Get saved location
//   LocationModel? getSavedLocation() {
//     try {
//       final data = _box?.get(_locationKey);
//       if (data != null && data is Map) {
//         return LocationModel(
//           latitude: data['latitude'] as double,
//           longitude: data['longitude'] as double,
//           address: data['address'] as String? ?? '',
//           placeName: data['placeName'] as String? ?? 'Saved Location',
//         );
//       }
//     } catch (e) {
//       print('❌ Error getting saved location: $e');
//     }
//     return null;
//   }

//   /// Clear saved location
//   Future<void> clearSavedLocation() async {
//     try {
//       await _box?.delete(_locationKey);
//     } catch (e) {
//       print('❌ Error clearing saved location: $e');
//     }
//   }

//   /// Check if location is saved
//   bool hasSavedLocation() {
//     return _box?.containsKey(_locationKey) ?? false;
//   }
// }
