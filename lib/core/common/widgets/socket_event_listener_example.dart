// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../services/socket_service.dart';

// /// Example widget showing how to listen to socket events in any screen
// /// You can use this pattern in your Activity, Home, or Profile screens
// class SocketEventListenerExample extends StatelessWidget {
//   const SocketEventListenerExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final socketService = Get.find<SocketService>();

//     return Column(
//       children: [
//         // Connection status indicator
//         Obx(() {
//           return Container(
//             padding: const EdgeInsets.all(8),
//             color: socketService.isConnected.value ? Colors.green : Colors.red,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   socketService.isConnected.value 
//                     ? Icons.cloud_done 
//                     : Icons.cloud_off,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   socketService.isConnected.value 
//                     ? 'Connected' 
//                     : 'Disconnected',
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           );
//         }),

//         // Listen to new booking requests
//         Obx(() {
//           final newBooking = socketService.newBookingRequest.value;
//           if (newBooking == null) return const SizedBox.shrink();

//           return Card(
//             color: Colors.blue[50],
//             child: ListTile(
//               leading: const Icon(Icons.add_alert, color: Colors.blue),
//               title: const Text('New Booking Request'),
//               subtitle: Text('Booking ID: ${newBooking['bookingId'] ?? 'N/A'}'),
//               trailing: IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () => socketService.newBookingRequest.value = null,
//               ),
//             ),
//           );
//         }),

//         // Listen to booking status updates
//         Obx(() {
//           final statusUpdate = socketService.bookingStatusUpdate.value;
//           if (statusUpdate == null) return const SizedBox.shrink();

//           return Card(
//             color: Colors.orange[50],
//             child: ListTile(
//               leading: const Icon(Icons.update, color: Colors.orange),
//               title: const Text('Booking Status Updated'),
//               subtitle: Text(
//                 'Status: ${statusUpdate['status'] ?? 'N/A'}\n'
//                 'Booking ID: ${statusUpdate['bookingId'] ?? 'N/A'}',
//               ),
//               trailing: IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () => socketService.bookingStatusUpdate.value = null,
//               ),
//             ),
//           );
//         }),

//         // Listen to booking cancellations
//         Obx(() {
//           final cancelled = socketService.bookingCancelled.value;
//           if (cancelled == null) return const SizedBox.shrink();

//           return Card(
//             color: Colors.red[50],
//             child: ListTile(
//               leading: const Icon(Icons.cancel, color: Colors.red),
//               title: const Text('Booking Cancelled'),
//               subtitle: Text(
//                 'Booking ID: ${cancelled['bookingId'] ?? 'N/A'}\n'
//                 'Reason: ${cancelled['reason'] ?? 'Not specified'}',
//               ),
//               trailing: IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () => socketService.bookingCancelled.value = null,
//               ),
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

// /// Simple mixin to handle socket events in any controller
// /// Usage: class MyController extends GetxController with SocketEventMixin
// mixin SocketEventMixin on GetxController {
//   late final SocketService socketService;

//   @override
//   void onInit() {
//     super.onInit();
//     socketService = Get.find<SocketService>();
//     _setupSocketListeners();
//   }

//   void _setupSocketListeners() {
//     // Listen to new booking request
//     ever(socketService.newBookingRequest, (booking) {
//       if (booking != null) {
//         onNewBookingRequest(booking);
//       }
//     });

//     // Listen to booking status update
//     ever(socketService.bookingStatusUpdate, (update) {
//       if (update != null) {
//         onBookingStatusUpdate(update);
//       }
//     });

//     // Listen to booking cancellation
//     ever(socketService.bookingCancelled, (cancelled) {
//       if (cancelled != null) {
//         onBookingCancelled(cancelled);
//       }
//     });
//   }

//   // Override these methods in your controller
//   void onNewBookingRequest(Map<String, dynamic> booking) {
//     // Handle new booking request
//     print('New booking request: $booking');
//   }

//   void onBookingStatusUpdate(Map<String, dynamic> update) {
//     // Handle booking status update
//     print('Booking status update: $update');
//   }

//   void onBookingCancelled(Map<String, dynamic> cancelled) {
//     // Handle booking cancellation
//     print('Booking cancelled: $cancelled');
//   }
// }
