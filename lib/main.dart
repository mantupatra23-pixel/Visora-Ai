// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'state/app_state.dart';

// import your screens here (make sure files exist)
import 'screens/home.dart';
import 'screens/script_input.dart';
import 'screens/characters.dart';
import 'screens/scene_builder.dart';
import 'screens/voice_lipsync.dart';
import 'screens/render_settings.dart';
import 'screens/render_status.dart';
import 'screens/player.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // <-- set your backend URL here (you said changed to visora-ai-yclw.onrender.com)
  final api = ApiService(baseUrl: 'https://visora-ai-yclw.onrender.com');

  runApp(ChangeNotifierProvider(
    create: (_) => AppState(api: api),
    child: const VisoraApp(),
  ));
}

class VisoraApp extends StatelessWidget {
  const VisoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visora AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/script': (_) => const ScriptInputScreen(),
        '/characters': (_) => const CharactersScreen(),
        '/scenes': (_) => const SceneBuilderScreen(),
        '/voice': (_) => const VoiceLipsyncScreen(),
        '/render': (_) => const RenderSettingsScreen(),
        '/status': (_) => const RenderStatusScreen(),
        '/player': (_) => const VideoPlayerScreen(),
      },
    );
  }
}
