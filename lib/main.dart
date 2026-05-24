import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/common/constants/language.dart';
import 'core/init/app_initializer.dart';
import 'core/network/constants/cache_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/splash_screen.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': AppLanguages.en,
    'fr': AppLanguages.fr,
    'pcm': AppLanguages.pcm,
  };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initializeApp();
  runApp(MyApp()); 
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box(ApiCacheConstants.settingsCacheKey);
    final savedCode = settingsBox.get('locale_code', defaultValue: 'en') as String;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flutter_izu',
      theme: AppTheme.light,
      translations: AppTranslations(),
      locale: Locale(savedCode),
      fallbackLocale: const Locale('en'),
      home: SplashScreen(),
    );
  }
}
