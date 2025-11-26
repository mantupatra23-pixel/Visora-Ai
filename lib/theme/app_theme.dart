import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    final primary = Color(0xFF0F4C81);
    final accent = Color(0xFFFF7A59);
    return ThemeData(
      primaryColor: primary,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accent),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(backgroundColor: primary, elevation: 0),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: accent),
      textTheme: TextTheme(
        headline6: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
        bodyText2: TextStyle(fontFamily: 'Inter'),
      ),
    );
  }

  static ThemeData dark() {
    final primary = Color(0xFF0F4C81);
    final accent = Color(0xFFFF7A59);
    return ThemeData.dark().copyWith(
      primaryColor: primary,
      colorScheme: ColorScheme.dark(secondary: accent),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: accent),
    );
  }
}
