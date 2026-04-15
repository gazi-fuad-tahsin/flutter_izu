import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutx_core/flutx_core.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket _socket;
  bool _isConnected = false;
  String? _currentUserId;

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  bool get isConnected => _isConnected;
  String? get currentUserId => _currentUserId;
  IO.Socket get socket => _socket;

  /// Connect to socket server
  Future<void> connect(String userId, {String? token}) async {
    try {
      _currentUserId = userId;

      // Get socket URL from your API constants or environment
      const String socketUrl = 'http://10.10.5.67:5008';

      if (kDebugMode) {
        DPrint.log('🔌 Connecting to Socket: $socketUrl with userId: $userId');
      }

      _socket = IO.io(
        socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({'userId': userId})
            .setAuth({'Authorization': token ?? ''})
            .build(),
      );

      // Setup event listeners
      _setupEventListeners();

      // Connect
      _socket.connect();
    } catch (e) {
      if (kDebugMode) {
        DPrint.error('❌ Socket connection error: $e');
      }
      rethrow;
    }
  }

  /// Setup socket event listeners
  void _setupEventListeners() {
    _socket.on('connect', (_) {
      _isConnected = true;
      if (kDebugMode) {
        DPrint.log('✅ Socket connected: ${_socket.id}');
      }
    });

    _socket.on('disconnect', (_) {
      _isConnected = false;
      if (kDebugMode) {
        DPrint.log('❌ Socket disconnected');
      }
    });

    _socket.on('error', (error) {
      if (kDebugMode) {
        DPrint.error('⚠️  Socket error: $error');
      }
    });

    // Handle reconnection attempts
    _socket.on('connect_error', (error) {
      if (kDebugMode) {
        DPrint.error('⚠️  Socket connection error: $error');
      }
    });

    _socket.on('reconnect_attempt', (_) {
      if (kDebugMode) {
        DPrint.log('🔄 Socket reconnection attempt...');
      }
    });

    _socket.on('reconnect', (_) {
      _isConnected = true;
      if (kDebugMode) {
        DPrint.log('✅ Socket reconnected');
      }
    });

    // User joined notification
    _socket.on('userJoined', (data) {
      if (kDebugMode) {
        DPrint.log('👤 User joined: $data');
      }
    });

    // New message notification
    _socket.on('newMessage', (data) {
      if (kDebugMode) {
        DPrint.log('💬 New message: $data');
      }
    });

    // Booking status update
    _socket.on('bookingStatusUpdate', (data) {
      if (kDebugMode) {
        DPrint.log('📋 Booking status updated: $data');
      }
    });

    // Service request notification
    _socket.on('serviceRequest', (data) {
      if (kDebugMode) {
        DPrint.log('🔔 Service request: $data');
      }
    });
  }

  /// Emit event to server
  void emit(String event, dynamic data) {
    if (_isConnected) {
      _socket.emit(event, data);
      if (kDebugMode) {
        DPrint.log('📤 Emitted event: $event with data: $data');
      }
    } else {
      if (kDebugMode) {
        DPrint.warn('⚠️  Socket not connected, cannot emit: $event');
      }
    }
  }

  /// Listen to socket events
  void on(String event, dynamic Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  /// Listen to socket events once
  void once(String event, dynamic Function(dynamic) callback) {
    _socket.once(event, callback);
  }

  /// Disconnect socket
  Future<void> disconnect() async {
    try {
      if (_isConnected) {
        _socket.disconnect();
        _isConnected = false;
        _currentUserId = null;
        if (kDebugMode) {
          DPrint.log('🔌 Socket disconnected');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        DPrint.error('❌ Error disconnecting socket: $e');
      }
    }
  }

  /// Reconnect socket
  Future<void> reconnect() async {
    try {
      if (_currentUserId != null) {
        await disconnect();
        await Future.delayed(const Duration(seconds: 1));
        await connect(_currentUserId!);
      }
    } catch (e) {
      if (kDebugMode) {
        DPrint.error('❌ Error reconnecting socket: $e');
      }
    }
  }
}
