// lib/core/network/models/base_response.dart

import 'error_source.dart';

class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<ErrorSource>? errorSources;

  BaseResponse({
    required this.success,
    required this.message,
    this.data,
    this.errorSources,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    // Handle data field - it can be null, empty string, or actual data
    // Also check for 'date' field as a fallback (some APIs have typos)
    T? parsedData;
    final dataField = json['data'] ?? json['date'];
    print('📦 BaseResponse.fromJson - dataField type: ${dataField.runtimeType}, isNull: ${dataField == null}');

    if (dataField != null) {
      // Check if data is an empty string or non-map primitive
      if (dataField is String && dataField.isEmpty) {
        // Empty string - don't try to parse
        parsedData = null;
      } else if (dataField is Map || dataField is List) {
        // Valid JSON structure - parse it
        try {
          print('📦 BaseResponse calling fromJsonT with dataField');
          parsedData = fromJsonT(dataField);
          print('📦 BaseResponse.fromJsonT returned successfully');
        } catch (e) {
          // Parsing failed - set to null
          print('❌ BaseResponse.fromJson CAUGHT EXCEPTION: $e');
          print('   Stack: ${StackTrace.current}');
          parsedData = null;
        }
      } else {
        // Primitive value (number, bool, etc.) - pass directly
        try {
          print('📦 BaseResponse calling fromJsonT with primitive: ${dataField.runtimeType}');
          parsedData = fromJsonT(dataField);
        } catch (e) {
          print('❌ BaseResponse.fromJson CAUGHT EXCEPTION (primitive): $e');
          parsedData = null;
        }
      }
    }

    return BaseResponse<T>(
      success: json['success'] ?? json['status'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
      errorSources: json['errorSources'] != null
          ? (json['errorSources'] as List)
                .map((e) => ErrorSource.fromJson(e))
                .toList()
          : null,
    );
  }

  String get combinedErrorMessage {
    if (errorSources == null || errorSources!.isEmpty) return message;
    return errorSources!.map((e) => e.message).join('\n');
  }
}
