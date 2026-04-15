import 'dart:convert';

class JwtDecoder {
  /// Extract user ID from JWT token
  static String? extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Decode the payload (second part)
      String payload = parts[1];
      
      // Add padding if needed
      int padLength = 4 - (payload.length % 4);
      if (padLength < 4) {
        payload += '=' * padLength;
      }

      final decoded = utf8.decode(base64Url.decode(payload));
      final json = jsonDecode(decoded) as Map<String, dynamic>;
      
      return json['id'] as String?;
    } catch (e) {
      return null;
    }
  }
}
