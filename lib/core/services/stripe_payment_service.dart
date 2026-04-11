// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// class StripePaymentService {
//   String? lastErrorMessage;

//   bool get _supportsStripePaymentSheet {
//     if (kIsWeb) return false;
//     return defaultTargetPlatform == TargetPlatform.iOS ||
//         defaultTargetPlatform == TargetPlatform.android;
//   }

//   /// Initialize payment sheet with Stripe
//   Future<bool> initializePaymentSheet({
//     required String clientSecret,
//     required String amount,
//     required String email,
//   }) async {
//     lastErrorMessage = null;

//     if (!_supportsStripePaymentSheet) {
//       lastErrorMessage =
//           'Stripe card payment is available only on Android/iOS. Please run this flow on a mobile device.';
//       debugPrint('❌ $lastErrorMessage');
//       return false;
//     }

//     try {
//       debugPrint('💳 Initializing Stripe payment sheet...');
//       debugPrint('💳 Amount: $amount, Email: $email');

//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           merchantDisplayName: 'YAMA UK',
//           // Use default flow for a simple card payment experience.
//           customFlow: false,
//           style: ThemeMode.light,
//           appearance: const PaymentSheetAppearance(
//             colors: PaymentSheetAppearanceColors(
//               primary: Color(0xFF000000),
//             ),
//           ),
//           paymentIntentClientSecret: clientSecret,
//         ),
//       );

//       debugPrint('✅ Payment sheet initialized successfully');
//       return true;
//     } catch (e) {
//       lastErrorMessage = e.toString();
//       debugPrint('❌ Error initializing payment sheet: $e');
//       return false;
//     }
//   }

//   /// Present payment sheet to user
//   Future<bool> presentPaymentSheet() async {
//     try {
//       debugPrint('📱 Presenting payment sheet...');
//       await Stripe.instance.presentPaymentSheet();
//       debugPrint('✅ Payment completed successfully');
//       return true;
//     } catch (e) {
//       if (e is StripeException) {
//         lastErrorMessage = e.error.localizedMessage ?? 'Stripe payment failed.';
//         debugPrint('❌ Stripe error: ${e.error.localizedMessage}');
//         // Check if payment was cancelled
//         final code = e.error.code.toString();
//         if (code.toLowerCase().contains('cancelled')) {
//           debugPrint('⚠️ Payment cancelled by user');
//         }
//       } else {
//         lastErrorMessage = e.toString();
//         debugPrint('❌ Payment error: $e');
//       }
//       return false;
//     }
//   }

//   /// Process complete payment flow
//   Future<bool> processPayment({
//     required String clientSecret,
//     required String amount,
//     required String email,
//   }) async {
//     try {
//       // Initialize payment sheet
//       final initialized = await initializePaymentSheet(
//         clientSecret: clientSecret,
//         amount: amount,
//         email: email,
//       );

//       if (!initialized) {
//         debugPrint('❌ Failed to initialize payment sheet');
//         return false;
//       }

//       // Present payment sheet
//       final completed = await presentPaymentSheet();
//       return completed;
//     } catch (e) {
//       lastErrorMessage = e.toString();
//       debugPrint('❌ Error processing payment: $e');
//       return false;
//     }
//   }
// }
