import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/common/constants/texts.dart';
import '../../../../core/network/constants/cache_constants.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({super.key});

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  String _selectedLanguage = 'English';

  String get _updateButtonLabel {
    switch (_selectedLanguage) {
      case 'Français':
        return 'Mettre à jour';
      case 'Pidgin':
        return 'Update Am';
      default:
        return 'Update';
    }
  }

  @override
  void initState() {
    super.initState();
    final code = Get.locale?.languageCode ?? 'en';
    if (code == 'fr') {
      _selectedLanguage = 'Français';
    } else if (code == 'pcm') {
      _selectedLanguage = 'Pidgin';
    } else {
      _selectedLanguage = 'English';
    }
  }

  final List<Map<String, String>> languages = [
    {
      'name': 'English',
      'flag': '🇬🇧',
      'code': 'en',
    },
    {
      'name': 'Français',
      'flag': '🇫🇷',
      'code': 'fr',
    },
    {
      'name': 'Pidgin',
      'flag': '🇳🇬',
      'code': 'pcm',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          appTexts.changeLanguage.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final language = languages[index];
                  final isSelected = _selectedLanguage == language['name'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLanguage = language['name']!;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF2870BC) : Colors.grey.shade200,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                language['flag']!,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                language['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? const Color(0xFF2870BC) : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2870BC),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final selected = languages.firstWhere(
                      (l) => l['name'] == _selectedLanguage,
                      orElse: () => {'code': 'en'},
                    );
                    final code = selected['code']!;
                    Hive.box(ApiCacheConstants.settingsCacheKey)
                        .put('locale_code', code);
                    Get.updateLocale(Locale(code));
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2870BC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _updateButtonLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
