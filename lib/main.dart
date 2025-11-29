// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/app_state.dart';
import 'services/api_service.dart';

// screens
import 'screens/home.dart';
import 'screens/script_input.dart';
import 'screens/characters.dart';
import 'screens/scene_builder.dart';
import 'screens/render_settings.dart';
import 'screens/render_status.dart';
import 'screens/player.dart';

// theme
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // set your backend base URL here (use your render URL)
  final api = ApiService(baseUrl: 'https://visora-ai-yclw.onrender.com');

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(api: api),
      child: const VisoraApp(),
    ),
  );
}

class VisoraApp extends StatelessWidget {
  const VisoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Visora AI',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/script': (context) => const ScriptInputScreen(),
        '/characters': (context) => const CharactersScreen(),
        '/scenes': (context) => const SceneBuilderScreen(),
        '/render_settings': (context) => const RenderSettingsScreen(),
        '/status': (context) => const RenderStatusScreen(),
        '/player': (context) => const VideoPlayerScreen(),
      },
    );
  }
}
