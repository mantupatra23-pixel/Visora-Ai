// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// app state & services
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

// optional theme file (if you created it)
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // set your backend base URL here
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
      theme: AppTheme.light,      // make sure lib/theme/app_theme.dart exists
      darkTheme: AppTheme.dark,   // and exposes AppTheme.light / AppTheme.dark
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/script': (_) => const ScriptInputScreen(),
        '/characters': (_) => const CharactersScreen(),
        '/builder': (_) => const SceneBuilderScreen(),
        '/render-settings': (_) => const RenderSettingsScreen(),
        '/render-status': (_) => const RenderStatusScreen(),
        '/player': (_) => const VideoPlayerScreen(),
      },
      // if you want to handle unknown routes:
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      useInheritedMediaQuery: true,
    );
  }
}
