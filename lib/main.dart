import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'core/init/app_initializer.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Now initialize the app
  await AppInitializer.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter_izu',
      theme: AppTheme.light,
      home:  SplashScreen(),
    );
  }
}
