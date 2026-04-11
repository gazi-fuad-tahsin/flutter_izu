// import 'dart:convert';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// /// Google Places API service for autocomplete suggestions
// class GooglePlacesService {
//   final String _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  
//   /// Get place autocomplete suggestions
//   Future<List<PlaceSuggestion>> getPlaceSuggestions(String query) async {
//     if (query.isEmpty || _apiKey.isEmpty) {
//       print('⚠️ Places API: Empty query or API key');
//       return [];
//     }

//     try {
//       final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_apiKey&components=country:gb', // GB for UK
//       );

//       print('🔍 Places API Request: $query');
//       final response = await http.get(url);
//       print('📡 Places API Response Status: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('📦 Places API Response: ${data['status']}');
        
//         if (data['status'] == 'OK') {
//           final predictions = data['predictions'] as List;
//           print('✅ Found ${predictions.length} suggestions');
//           return predictions
//               .map((pred) => PlaceSuggestion.fromJson(pred))
//               .toList();
//         } else {
//           print('❌ Places API error: ${data['status']} - ${data['error_message'] ?? 'No message'}');
//         }
//       } else {
//         print('❌ HTTP Error: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       print('❌ Error getting place suggestions: $e');
//     }
    
//     return [];
//   }

//   /// Get place details (lat/lng) from place_id
//   Future<PlaceDetails?> getPlaceDetails(String placeId) async {
//     if (placeId.isEmpty || _apiKey.isEmpty) {
//       print('⚠️ Place Details API: Empty placeId or API key');
//       return null;
//     }

//     try {
//       final url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey&fields=geometry,formatted_address,name',
//       );

//       print('🔍 Getting place details for: $placeId');
//       final response = await http.get(url);
//       print('📡 Place Details Response Status: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('📦 Place Details Status: ${data['status']}');
        
//         if (data['status'] == 'OK') {
//           final details = PlaceDetails.fromJson(data['result']);
//           print('✅ Place details retrieved: ${details.name} at (${details.latitude}, ${details.longitude})');
//           return details;
//         } else {
//           print('❌ Place Details API error: ${data['status']} - ${data['error_message'] ?? 'No message'}');
//         }
//       } else {
//         print('❌ HTTP Error: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       print('❌ Error getting place details: $e');
//     }
    
//     return null;
//   }
// }

// /// Model for place autocomplete suggestion
// class PlaceSuggestion {
//   final String placeId;
//   final String description;
//   final String mainText;
//   final String secondaryText;

//   PlaceSuggestion({
//     required this.placeId,
//     required this.description,
//     required this.mainText,
//     required this.secondaryText,
//   });

//   factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
//     return PlaceSuggestion(
//       placeId: json['place_id'] ?? '',
//       description: json['description'] ?? '',
//       mainText: json['structured_formatting']?['main_text'] ?? json['description'],
//       secondaryText: json['structured_formatting']?['secondary_text'] ?? '',
//     );
//   }
// }

// /// Model for place details with coordinates
// class PlaceDetails {
//   final double latitude;
//   final double longitude;
//   final String formattedAddress;
//   final String name;

//   PlaceDetails({
//     required this.latitude,
//     required this.longitude,
//     required this.formattedAddress,
//     required this.name,
//   });

//   factory PlaceDetails.fromJson(Map<String, dynamic> json) {
//     final geometry = json['geometry'];
//     final location = geometry['location'];
    
//     return PlaceDetails(
//       latitude: location['lat']?.toDouble() ?? 0.0,
//       longitude: location['lng']?.toDouble() ?? 0.0,
//       formattedAddress: json['formatted_address'] ?? '',
//       name: json['name'] ?? '',
//     );
//   }
// }
