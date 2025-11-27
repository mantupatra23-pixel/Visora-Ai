// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Light theme getter
  static ThemeData get light {
    final base = ThemeData.light();
    return base.copyWith(
      useMaterial3: false,
      primaryColor: const Color(0xFF0A74FF),
      scaffoldBackgroundColor: Colors.white,
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFF0A74FF),
        secondary: const Color(0xFF00BFA6),
        brightness: Brightness.light,
      ),
      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      textTheme: _buildTextTheme(base.textTheme, Brightness.light),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // Dark theme getter
  static ThemeData get dark {
    final base = ThemeData.dark();
    return base.copyWith(
      useMaterial3: false,
      primaryColor: const Color(0xFF0A74FF),
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFF0A74FF),
        secondary: const Color(0xFF00BFA6),
        brightness: Brightness.dark,
      ),
      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0,
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
      ),
      textTheme: _buildTextTheme(base.textTheme, Brightness.dark),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // Centralized text theme builder mapping old names to new ones
  static TextTheme _buildTextTheme(TextTheme base, Brightness brightness) {
    final color = brightness == Brightness.dark ? Colors.white : Colors.black87;

    return base.copyWith(
      // titleLarge -> titleLarge
      titleLarge: base.titleLarge?.copyWith(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ) ??
          TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w700),

      // bodyMedium -> bodyMedium
      bodyMedium: base.bodyMedium?.copyWith(
            color: color,
            fontSize: 14,
          ) ??
          TextStyle(color: color, fontSize: 14),

      // titleMedium -> titleMedium
      titleMedium: base.titleMedium?.copyWith(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ) ??
          TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w600),

      // bodySmall -> bodySmall
      bodySmall: base.bodySmall?.copyWith(
            color: color.withOpacity(0.8),
            fontSize: 12,
          ) ??
          TextStyle(color: color.withOpacity(0.8), fontSize: 12),
    );
  }
}
