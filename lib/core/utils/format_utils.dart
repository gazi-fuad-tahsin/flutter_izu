/// Central utility for date and phone number formatting across the application
class FormatUtils {
  // ─── Date Formatting ────────────────────────────────────────────────────
  
  /// Format date to UK format (dd/MM/yyyy)
  /// Example: "2002-05-22T00:00:00.000Z" → "22/05/2002"
  static String formatDateToUK(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Not provided';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  /// Format date-time to UK format with time
  /// Example: "2026-04-09T14:30:00.000Z" → "09/04/2026 14:30"
  static String formatDateTimeToUK(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return 'Not provided';
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final date = '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
      final time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      return '$date $time';
    } catch (_) {
      return dateTimeStr;
    }
  }

  /// Format date to display format (e.g., "09 April 2026")
  static String formatDateToDisplay(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'Not provided';
    try {
      final date = DateTime.parse(dateStr);
      const months = ['January', 'February', 'March', 'April', 'May', 'June',
                      'July', 'August', 'September', 'October', 'November', 'December'];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  // ─── Phone Number Formatting ────────────────────────────────────────────
  
  /// Format phone number to UK format with +44 country code
  /// Returns:
  /// - "+44..." if already has +44
  /// - "+44..." if starts with 0 (converts 0 to +44)
  /// - original number otherwise
  static String formatPhoneNumberToUK(String phoneNumber) {
    if (phoneNumber.isEmpty) return 'Not provided';
    
    // If already has +44, return as is
    if (phoneNumber.startsWith('+44')) {
      return phoneNumber;
    }
    
    // If starts with 0, convert to +44
    if (phoneNumber.startsWith('0')) {
      return '+44${phoneNumber.substring(1)}';
    }
    
    // If it's digits without +44 or 0, assume it's the main part and add +44
    if (RegExp(r'^\d+$').hasMatch(phoneNumber)) {
      return '+44$phoneNumber';
    }
    
    // Return as is
    return phoneNumber;
  }

  /// Format phone number for display/editing (with or without country code based on preference)
  /// If it starts with +44, optionally convert to 0X format for display
  static String formatPhoneNumberForDisplay(String phoneNumber, {bool useUKCode = false}) {
    if (phoneNumber.isEmpty) return 'Not provided';
    
    if (useUKCode) {
      // Show with +44
      return formatPhoneNumberToUK(phoneNumber);
    } else {
      // Show with 0X format
      if (phoneNumber.startsWith('+44')) {
        return '0${phoneNumber.substring(3)}';
      }
      if (phoneNumber.startsWith('0')) {
        return phoneNumber;
      }
      return phoneNumber;
    }
  }

  /// Clean phone number - remove all non-digit characters except +
  static String cleanPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  }

  /// Check if phone number is valid UK format
  static bool isValidUKPhoneNumber(String phoneNumber) {
    final cleaned = cleanPhoneNumber(phoneNumber);
    // UK numbers should be: +44XXXXXXXXXX or 0XXXXXXXXXXX
    if (cleaned.startsWith('+44')) {
      return cleaned.length >= 12; // +44 + at least 10 digits
    }
    if (cleaned.startsWith('0')) {
      return cleaned.length >= 11; // 0 + at least 10 digits
    }
    return false;
  }
}
