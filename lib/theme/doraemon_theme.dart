import 'package:flutter/material.dart';

class DoraemonTheme {
  // Doraemon Anime Palette
  static const Color doraemonBlue = Color(0xFF00A0E9);
  static const Color doraemonSkyLight = Color(0xFFE0F2FE);
  static const Color bellYellow = Color(0xFFFFD800);
  static const Color collarRed = Color(0xFFE60012);
  static const Color cloudWhite = Color(0xFFF8FAFC);
  static const Color darkBg = Color(0xFF0B132B);
  static const Color cardDark = Color(0xFF1C2541);
  static const Color textDark = Color(0xFF0F172A);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0F9FF),
    colorScheme: const ColorScheme.light(
      primary: doraemonBlue,
      secondary: bellYellow,
      error: collarRed,
      surface: Colors.white,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0F172A),
      elevation: 0,
      centerTitle: false,
    ),
    fontFamily: 'SF Pro Display',
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF38BDF8),
      secondary: bellYellow,
      error: collarRed,
      surface: cardDark,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: cardDark,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    fontFamily: 'SF Pro Display',
  );
}
