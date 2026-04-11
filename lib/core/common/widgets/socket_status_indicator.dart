// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../services/socket_service.dart';

// /// Socket connection status indicator
// /// Add this to your screen to show real-time connection status
// class SocketStatusIndicator extends StatelessWidget {
//   final bool showLabel;
//   final double iconSize;
  
//   const SocketStatusIndicator({
//     super.key,
//     this.showLabel = true,
//     this.iconSize = 16,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final socketService = Get.find<SocketService>();

//     return Obx(() {
//       final isConnected = socketService.isConnected.value;
//       final isConnecting = socketService.isConnecting.value;
      
//       if (isConnecting) {
//         return _buildIndicator(
//           icon: Icons.sync,
//           color: Colors.orange,
//           label: 'Connecting...',
//           isAnimated: true,
//         );
//       }
      
//       return _buildIndicator(
//         icon: isConnected ? Icons.cloud_done : Icons.cloud_off,
//         color: isConnected ? Colors.green : Colors.red,
//         label: isConnected ? 'Connected' : 'Disconnected',
//         isAnimated: false,
//       );
//     });
//   }

//   Widget _buildIndicator({
//     required IconData icon,
//     required Color color,
//     required String label,
//     required bool isAnimated,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           isAnimated
//               ? SizedBox(
//                   width: iconSize,
//                   height: iconSize,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(color),
//                   ),
//                 )
//               : Icon(icon, color: color, size: iconSize),
//           if (showLabel) ...[
//             const SizedBox(width: 6),
//             Text(
//               label,
//               style: TextStyle(
//                 color: color,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// /// Simple badge showing just connection dot
// class SocketConnectionBadge extends StatelessWidget {
//   final double size;
  
//   const SocketConnectionBadge({
//     super.key,
//     this.size = 8,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final socketService = Get.find<SocketService>();

//     return Obx(() {
//       final isConnected = socketService.isConnected.value;
      
//       return Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: isConnected ? Colors.green : Colors.red,
//           boxShadow: isConnected
//               ? [
//                   BoxShadow(
//                     color: Colors.green.withOpacity(0.5),
//                     blurRadius: 4,
//                     spreadRadius: 1,
//                   ),
//                 ]
//               : null,
//         ),
//       );
//     });
//   }
// }

// /// Full-width banner showing socket status (for debugging)
// class SocketStatusBanner extends StatelessWidget {
//   const SocketStatusBanner({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final socketService = Get.find<SocketService>();

//     return Obx(() {
//       final isConnected = socketService.isConnected.value;
//       final isConnecting = socketService.isConnecting.value;
      
//       // Don't show if connected (only show issues)
//       if (isConnected) return const SizedBox.shrink();
      
//       return Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         color: isConnecting ? Colors.orange : Colors.red,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (isConnecting)
//               const SizedBox(
//                 width: 14,
//                 height: 14,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//             else
//               const Icon(Icons.cloud_off, color: Colors.white, size: 16),
//             const SizedBox(width: 8),
//             Text(
//               isConnecting ? 'Connecting to server...' : 'Disconnected',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
