import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    scaffoldBackgroundColor: AppColors.primaryWhite,
    primaryColor: AppColors.homeBG,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: AppColors.textBlack,
      displayColor: AppColors.textBlack,
    ),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: AppColors.primaryWhite),
      backgroundColor: AppColors.homeBG,
      titleTextStyle: TextStyle(
        fontSize: 24,
        color: AppColors.primaryWhite,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.containerBG,
        foregroundColor: AppColors.primaryWhite,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.containerBG),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primaryWhite,
      unselectedItemColor: AppColors.primaryWhite.withValues(alpha: 0.6),
      backgroundColor: AppColors.containerBG,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.containerBG,
      onPrimary: AppColors.primaryWhite,
    ).copyWith(surface: AppColors.primaryWhite),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.grey),
    ),
  );
}
