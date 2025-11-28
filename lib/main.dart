// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// App state & services
import 'state/app_state.dart';
import 'services/api_service.dart';

// Screens (ensure these files exist; placeholders ok for now)
import 'screens/home.dart';
import 'screens/script_input.dart';
import 'screens/characters.dart';
import 'screens/scene_builder.dart';
import 'screens/voice_lipsync.dart';
import 'screens/render_settings.dart';
import 'screens/render_status.dart';
import 'screens/player.dart';

// Optional theme file (if you added)
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // API service instance (backend base URL)
  final api = ApiService(baseUrl: 'https://visora-backend-v2.onrender.com');

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
      // If you added theme/app_theme.dart use it, otherwise fallback to default ThemeData
      theme: (AppTheme.available)
          ? AppTheme.light
          : ThemeData(
              primarySwatch: Colors.deepPurple,
              useMaterial3: true,
            ),
      darkTheme: (AppTheme.available) ? AppTheme.dark : null,
      initialRoute: '/',
      routes: {
        '/': (ctx) => const HomeScreen(),
        '/script': (ctx) => const ScriptInputScreen(),
        '/characters': (ctx) => const CharactersScreen(),
        '/scenes': (ctx) => const SceneBuilderScreen(),
        '/voice': (ctx) => const VoiceLipsyncScreen(),
        '/render': (ctx) => const RenderSettingsScreen(),
        '/status': (ctx) => const RenderStatusScreen(),
        '/player': (ctx) => const VideoPlayerScreen(),
      },
      // basic fallback route
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }
}
