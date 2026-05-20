import 'package:flutter/foundation.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends GetxService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket _socket;
  bool _isConnected = false;
  String? _currentUserId;

  // Observable for request-confirmation event
  final Rxn<Map<String, dynamic>> requestConfirmation = Rxn<Map<String, dynamic>>();

  // Observables for messaging events
  final Rxn<Map<String, dynamic>> newMessage = Rxn<Map<String, dynamic>>();
  final Rxn<Map<String, dynamic>> messageSent = Rxn<Map<String, dynamic>>();

  // Observable for real-time notifications
  final Rxn<Map<String, dynamic>> liveNotification = Rxn<Map<String, dynamic>>();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  bool get isConnected {
    try {
      return _isConnected && _socket.connected;
    } catch (e) {
      return false;
    }
  }
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
        DPrint.log(
            "\n╔═══════════════════════════════════════════════════════════════");
        DPrint.log("║ ✅ SOCKET CONNECTED");
        DPrint.log(
            "╠═══════════════════════════════════════════════════════════════");
        DPrint.log("║ Socket ID: ${_socket.id}");
        DPrint.log("║ Current User ID: $_currentUserId");
        DPrint.log(
            "╚═══════════════════════════════════════════════════════════════\n");
      }
      // Emit join with userId after connection
      if (_currentUserId != null && _currentUserId!.isNotEmpty) {
        _socket.emit('join', _currentUserId);
        if (kDebugMode) {
          DPrint.log('📤 Emitted join with userId: $_currentUserId');
        }
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
      if (_currentUserId != null && _currentUserId!.isNotEmpty) {
        _socket.emit('join', _currentUserId);
        if (kDebugMode) {
          DPrint.log('📤 Re-emitted join with userId: $_currentUserId');
        }
      }
    });

    // User joined notification
    _socket.on('userJoined', (data) {
      if (kDebugMode) {
        DPrint.log('👤 User joined: $data');
      }
    });

    // New message received by recipient
    _socket.on('newMessage', (data) {
      if (kDebugMode) {
        DPrint.log('💬 newMessage event: $data');
      }
      if (data != null && data is Map) {
        newMessage.value = Map<String, dynamic>.from(data);
      }
    });

    // Real-time notification event
    _socket.on('notification', (data) {
      if (kDebugMode) {
        DPrint.log('🔔 notification event: $data');
      }
      if (data != null && data is Map) {
        liveNotification.value = Map<String, dynamic>.from(data);
      }
    });

    // Message delivery confirmation to sender
    _socket.on('messageSent', (data) {
      if (kDebugMode) {
        DPrint.log('📨 messageSent event: $data');
      }
      if (data != null && data is Map) {
        messageSent.value = Map<String, dynamic>.from(data);
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

    // Provider ready confirmation event
    _socket.on('request-confirmation', (data) {
      DPrint.log(
          "\n╔═══════════════════════════════════════════════════════════════");
      DPrint.log("║ 📬 REQUEST-CONFIRMATION EVENT RECEIVED");
      DPrint.log(
          "╠═══════════════════════════════════════════════════════════════");
      DPrint.log("║ Raw Data: $data");
      DPrint.log("║ Data Type: ${data.runtimeType}");
      DPrint.log(
          "╚═══════════════════════════════════════════════════════════════\n");

      if (data != null && data is Map) {
        final mappedData = Map<String, dynamic>.from(data);
        DPrint.log('✅ Updating requestConfirmation observable with: $mappedData');
        requestConfirmation.value = mappedData;
        DPrint.log('✅ Observable value is now: ${requestConfirmation.value}');
      } else {
        DPrint.log('⚠️ Data is null or not a Map: $data');
      }
    });
  }

  /// Emit event to server
  void emit(String event, dynamic data) {
    DPrint.log(
        "\n╔═══════════════════════════════════════════════════════════════");
    DPrint.log("║ 📤 SOCKET EMIT");
    DPrint.log(
        "╠═══════════════════════════════════════════════════════════════");
    DPrint.log("║ Event: $event");
    DPrint.log("║ Data: $data");
    DPrint.log("║ Connected: $_isConnected");
    DPrint.log(
        "╚═══════════════════════════════════════════════════════════════\n");
    
    if (_isConnected) {
      _socket.emit(event, data);
      DPrint.log('✅ Event emitted successfully');
    } else {
      DPrint.log('❌ Socket not connected, cannot emit: $event');
      DPrint.log('   Socket state - _isConnected: $_isConnected');
      DPrint.log('   Socket state - connected: ${_socket.connected}');
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
