// import 'package:get/get.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// import '../network/constants/api_constants.dart';
// import '../network/services/auth_storage_service.dart';
// import '../utils/debug_print.dart';
// import 'sound_service.dart';

// /// Socket Service for real-time communication
// /// Connects using baseDomain and userId as query parameter
// class SocketService extends GetxService {
//   IO.Socket? _socket;
//   final AuthStorageService _authStorageService = Get.find<AuthStorageService>();
  
//   // Observable connection status
//   final isConnected = false.obs;
//   final isConnecting = false.obs;
  
//   // Booking events observables
//   final newBookingRequest = Rxn<Map<String, dynamic>>();
//   final bookingStatusUpdate = Rxn<Map<String, dynamic>>();
//   final bookingCancelled = Rxn<Map<String, dynamic>>();

//   /// Exposes the raw socket for screens that need to add direct .on() listeners
//   IO.Socket? get rawSocket => _socket;

//   /// Initialize and connect to socket
//   Future<void> connect() async {
//     if (_socket != null && _socket!.connected) {
//       DPrint.log('🔌 Socket already connected');
//       return;
//     }

//     try {
//       isConnecting.value = true;
      
//       // Get userId from storage
//       final userId = await _authStorageService.getUserId();
      
//       if (userId == null || userId.isEmpty) {
//         DPrint.log('❌ Cannot connect socket: userId not found');
//         isConnecting.value = false;
//         return;
//       }

//       DPrint.log(
//         "\n╔═══════════════════════════════════════════════════════════════",
//       );
//       DPrint.log("║ 🔌 SOCKET CONNECTION INITIALIZING");
//       DPrint.log(
//         "╠═══════════════════════════════════════════════════════════════",
//       );
//       DPrint.log("║ 🌐 Base Domain: ${ApiConstants.baseDomain}");
//       DPrint.log("║ 👤 User ID: $userId");
//       DPrint.log(
//         "╚═══════════════════════════════════════════════════════════════\n",
//       );

//       // Socket connection URL with userId as query parameter
//       final socketUrl = '${ApiConstants.baseDomain}?userId=$userId';

//       // Configure socket
//       _socket = IO.io(
//         socketUrl,
//         IO.OptionBuilder()
//             .setTransports(['websocket', 'polling']) // Use websocket first, fallback to polling
//             .enableAutoConnect()
//             .enableReconnection()
//             .setReconnectionAttempts(5)
//             .setReconnectionDelay(2000)
//             .setReconnectionDelayMax(5000)
//             .setTimeout(20000)
//             .setExtraHeaders({'userId': userId}) // Send userId in headers too
//             .build(),
//       );

//       _setupEventListeners();
      
//       isConnecting.value = false;
//     } catch (e) {
//       DPrint.log('❌ Socket connection error: $e');
//       isConnecting.value = false;
//       isConnected.value = false;
//     }
//   }

//   /// Setup all socket event listeners
//   void _setupEventListeners() {
//     if (_socket == null) return;

//     // Connection events
//     _socket!.onConnect((_) {
//       isConnected.value = true;
//       DPrint.log('✅ Socket connected successfully');
//       DPrint.log('🔌 Socket ID: ${_socket!.id}');
//     });

//     _socket!.onConnecting((_) {
//       DPrint.log('🔄 Socket connecting...');
//     });

//     _socket!.onDisconnect((_) {
//       isConnected.value = false;
//       DPrint.log('⚠️ Socket disconnected');
//     });

//     _socket!.onConnectError((error) {
//       isConnected.value = false;
//       DPrint.log('❌ Socket connection error: $error');
//     });

//     _socket!.onError((error) {
//       DPrint.log('❌ Socket error: $error');
//     });

//     _socket!.onReconnect((attempt) {
//       DPrint.log('🔄 Socket reconnecting... Attempt: $attempt');
//     });

//     _socket!.onReconnectError((error) {
//       DPrint.log('❌ Socket reconnection error: $error');
//     });

//     _socket!.onReconnectFailed((_) {
//       isConnected.value = false;
//       DPrint.log('❌ Socket reconnection failed');
//     });

//     // Business logic events
//     _setupBookingEventListeners();
//   }

//   /// Setup booking-related event listeners
//   void _setupBookingEventListeners() {
//     if (_socket == null) return;

//     // Listen for new booking requests
//     _socket!.on('new_booking_request', (data) {
//       DPrint.log(
//         "\n╔═══════════════════════════════════════════════════════════════",
//       );
//       DPrint.log("║ 📥 NEW BOOKING REQUEST RECEIVED");
//       DPrint.log(
//         "╠═══════════════════════════════════════════════════════════════",
//       );
//       DPrint.log("║ Data: $data");
//       DPrint.log(
//         "╚═══════════════════════════════════════════════════════════════\n",
//       );
      
//       if (data != null && data is Map) {
//         newBookingRequest.value = Map<String, dynamic>.from(data);
        
//         // Play order sound specifically for the provider accept/reject popup
//         try {
//           Get.find<SoundService>().playOrderSound();
//         } catch (e) {
//           DPrint.log('🔇 Sound service not available: $e');
//         }
        
//         // Show notification to user
//         _showBookingNotification(
//           title: 'New Booking Request',
//           message: 'You have received a new booking request',
//         );
//       }
//     });

//     // Listen for booking status updates
//     _socket!.on('booking_status_update', (data) {
//       DPrint.log(
//         "\n╔═══════════════════════════════════════════════════════════════",
//       );
//       DPrint.log("║ 🔄 BOOKING STATUS UPDATE RECEIVED");
//       DPrint.log(
//         "╠═══════════════════════════════════════════════════════════════",
//       );
//       DPrint.log("║ Data: $data");
//       DPrint.log(
//         "╚═══════════════════════════════════════════════════════════════\n",
//       );
      
//       if (data != null && data is Map) {
//         bookingStatusUpdate.value = Map<String, dynamic>.from(data);
        
//         // Play notification sound
//         try {
//           Get.find<SoundService>().playNotificationSound();
//         } catch (e) {
//           DPrint.log('🔇 Sound service not available: $e');
//         }
        
//         // Show notification to user
//         final status = data['status'] ?? 'updated';
//         _showBookingNotification(
//           title: 'Booking Update',
//           message: 'Your booking status has been $status',
//         );
//       }
//     });

//     // Listen for booking cancellation
//     _socket!.on('booking_cancelled', (data) {
//       DPrint.log(
//         "\n╔═══════════════════════════════════════════════════════════════",
//       );
//       DPrint.log("║ ❌ BOOKING CANCELLED RECEIVED");
//       DPrint.log(
//         "╠═══════════════════════════════════════════════════════════════",
//       );
//       DPrint.log("║ Data: $data");
//       DPrint.log(
//         "╚═══════════════════════════════════════════════════════════════\n",
//       );
      
//       if (data != null && data is Map) {
//         bookingCancelled.value = Map<String, dynamic>.from(data);
        
//         // Play notification sound
//         try {
//           Get.find<SoundService>().playNotificationSound();
//         } catch (e) {
//           DPrint.log('🔇 Sound service not available: $e');
//         }
        
//         // Show notification to user
//         _showBookingNotification(
//           title: 'Booking Cancelled',
//           message: 'A booking has been cancelled',
//         );
//       }
//     });
//   }

//   /// Show booking notification to user
//   void _showBookingNotification({
//     required String title,
//     required String message,
//   }) {
//     Get.snackbar(
//       title,
//       message,
//       snackPosition: SnackPosition.TOP,
//       duration: const Duration(seconds: 4),
//     );
//   }

//   /// Emit event to server
//   void emit(String event, dynamic data) {
//     if (_socket != null && _socket!.connected) {
//       DPrint.log('📤 Emitting event: $event with data: $data');
//       _socket!.emit(event, data);
//     } else {
//       DPrint.log('⚠️ Cannot emit event: Socket not connected');
//     }
//   }

//   /// Listen to custom event
//   void on(String event, Function(dynamic) callback) {
//     if (_socket != null) {
//       _socket!.on(event, callback);
//     }
//   }

//   /// Remove custom event listener
//   void off(String event) {
//     if (_socket != null) {
//       _socket!.off(event);
//     }
//   }

//   /// Disconnect socket
//   void disconnect() {
//     if (_socket != null) {
//       DPrint.log('🔌 Disconnecting socket...');
//       _socket!.disconnect();
//       _socket!.dispose();
//       _socket = null;
//       isConnected.value = false;
//     }
//   }

//   /// Reconnect socket
//   Future<void> reconnect() async {
//     disconnect();
//     await connect();
//   }

//   /// Check if socket is connected
//   bool get connected => _socket != null && _socket!.connected;

//   /// Get socket instance (for advanced use cases)
//   IO.Socket? get socket => _socket;

//   @override
//   void onClose() {
//     disconnect();
//     super.onClose();
//   }
// }
