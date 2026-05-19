import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'core/common/constants/language.dart';
import 'core/init/app_initializer.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': AppLanguages.en,
    'es': AppLanguages.es,
    'it': AppLanguages.it,
    'de': AppLanguages.de,
    'fr': AppLanguages.fr,
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Now initialize the app
  await AppInitializer.initializeApp();
  
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter_izu',
      theme: AppTheme.light,
      translations: AppTranslations(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      home: SplashScreen(),
    );
  }
}
