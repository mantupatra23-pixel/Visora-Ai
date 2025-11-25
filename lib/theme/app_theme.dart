import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    final primary = Color(0xFF0F4C81);
    final accent = Color(0xFFFF7A59);
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: createMaterialColor(primary))
          .copyWith(secondary: accent),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(backgroundColor: primary, elevation: 0, titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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
      colorScheme: ColorScheme.dark().copyWith(secondary: accent),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: accent),
    );
  }

  // helper to create MaterialColor from Color
  static MaterialColor createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;
    for (int i = 1; i < 10; i++) strengths.add(0.1 * i);
    for (var s in strengths) {
      final double ds = 0.5 - s;
      swatch[(s * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
