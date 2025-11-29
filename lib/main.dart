import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// state + api
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

// prefix the theme import to avoid name collisions (fixes AppTheme conflict)
import 'theme/app_theme.dart' as app_theme;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final api = ApiService(
    baseUrl: 'https://visora-ai-yclw.onrender.com',
  );

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

      // use prefixed theme names to avoid collision
      theme: app_theme.AppTheme.lightTheme,
      darkTheme: app_theme.AppTheme.darkTheme,

      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/script': (_) => const ScriptInputScreen(),
        '/characters': (_) => const CharactersScreen(),
        '/scenes': (_) => const SceneBuilderScreen(),
        '/settings': (_) => const RenderSettingsScreen(),
        '/status': (_) => const RenderStatusScreen(),

        // player route — ensure screens/player.dart defines VideoPlayerScreen
        '/player': (_) => VideoPlayerScreen(),
      },
    );
  }
}
