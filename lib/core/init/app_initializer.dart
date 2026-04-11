import 'package:flutter/widgets.dart';
import '../di/service_locator.dart';
import 'hive_intialization.dart';
import 'stripe_initializer.dart';


class AppInitializer {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await HiveInitialization.initHive();

    // Setup core services and wait for async services
    await setupServiceLocator();


    // await StripeInitializer.initStripe();

    // SocketService.initializeSocket(sl());
  }
}
