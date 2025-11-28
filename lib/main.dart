// lib/main.dart (FINAL)
// Replace your existing lib/main.dart with this file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// NOTE: keep these imports as-is if you already have these files.
// If you don't have them, tell me and I'll provide those files too.
import 'state/app_state.dart';
import 'services/api_service.dart';

// If you already have screen files, you can remove placeholders below
// and import your real screens instead. For now we'll use simple placeholders.
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure your backend base URL here
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
      title: 'Visora AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
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
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}

/// ----------------------
/// Home Screen
/// ----------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);

    // We try to read job info in a safe way — AppState should expose currentJob or similar
    final job = st.currentJob; // expecting RenderJob? in AppState
    final lastStatus = job?.status ?? 'created';
    final percent = (job?.progress ?? 0.0).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visora AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            tooltip: 'Profile',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/render'),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                child: const Text('Create Video', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 28),
            const Text('Last Job Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: Text(lastStatus, style: const TextStyle(fontSize: 16))),
              Text('${(percent * 100).toStringAsFixed(0)}%'),
            ]),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: percent),
            const SizedBox(height: 22),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _RouterChip(label: 'Characters', route: '/characters'),
                _RouterChip(label: 'Scenes', route: '/scenes'),
                _RouterChip(label: 'Render Settings', route: '/render'),
                _RouterChip(label: 'Status', route: '/status'),
                _RouterChip(label: 'Player', route: '/player'),
              ],
            ),
            const SizedBox(height: 20),
            if (st.lastError != null)
              Text('Error: ${st.lastError}', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: Text(
                  'Job ID: ${job?.id ?? "-"}\n\nUse Create Video → Start Render → Status to follow progress',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouterChip extends StatelessWidget {
  final String label;
  final String route;
  const _RouterChip({required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: () => Navigator.pushNamed(context, route),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}

/// ----------------------
/// Profile Screen (simple)
/// ----------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 44)),
            const SizedBox(height: 12),
            const Text('Mantu Patra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 6),
            Text('Visora user', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 14),
            ListTile(leading: const Icon(Icons.email), title: const Text('Email'), subtitle: const Text('you@example.com')),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Clear job (for testing)'),
              onTap: () {
                st.clearJob();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job cleared')));
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

/// ----------------------
/// Placeholder Screens
/// (If you already have these files, you can ignore these placeholders)
/// ----------------------

class ScriptInputScreen extends StatelessWidget {
  const ScriptInputScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    final ctr = TextEditingController(text: st.script ?? '');
    return Scaffold(
      appBar: AppBar(title: const Text('Script Input')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: ctr,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Script', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                st.setScript(ctr.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Script saved')));
              },
              child: const Text('Save Script'),
            )
          ],
        ),
      ),
    );
  }
}

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    // Expecting st.characters is List<CharacterModel> in your AppState
    final list = st.characters ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: list.length + 1,
        itemBuilder: (context, idx) {
          if (idx == list.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ElevatedButton(
                onPressed: () {
                  // demo add - real code should open add dialog
                  st.addCharacter({'name': 'New ${list.length + 1}'}); // if your AppState expects model, adapt
                },
                child: const Text('Add Character (demo)'),
              ),
            );
          }
          final c = list[idx];
          final name = (c is Map) ? (c['name'] ?? 'char') : (c?.name ?? 'char');
          return Card(
            child: ListTile(
              title: Text(name),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  st.removeCharacterAt(idx);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class SceneBuilderScreen extends StatelessWidget {
  const SceneBuilderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    final scenes = st.scenes ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('Scenes')),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: scenes.length,
        onReorder: (oldIdx, newIdx) {
          st.reorderScenes(oldIdx, newIdx);
        },
        itemBuilder: (context, idx) {
          final s = scenes[idx];
          final name = (s is Map) ? (s['name'] ?? 'scene') : (s?.name ?? 'scene');
          return Card(
            key: ValueKey('scene-$idx'),
            child: ListTile(title: Text('$name')),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => st.addScene({'name': 'Scene ${scenes.length + 1}'}),
        child: const Icon(Icons.add),
        tooltip: 'Add scene (demo)',
      ),
    );
  }
}

class VoiceLipsyncScreen extends StatelessWidget {
  const VoiceLipsyncScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Voice / Lipsync')), body: const Center(child: Text('Voice screen placeholder')));
  }
}

class RenderSettingsScreen extends StatelessWidget {
  const RenderSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Render Settings')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text('Use this screen to create a job and start rendering (demo)'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                try {
                  // call AppState method to start render job (expected in your AppState)
                  final id = await st.startRenderJobDemo(); // demo helper: implement or adapt
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Job created: $id')));
                  Navigator.pushNamed(context, '/status');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Create & Start (demo)'),
            )
          ],
        ),
      ),
    );
  }
}

class RenderStatusScreen extends StatefulWidget {
  const RenderStatusScreen({super.key});

  @override
  State<RenderStatusScreen> createState() => _RenderStatusScreenState();
}

class _RenderStatusScreenState extends State<RenderStatusScreen> {
  Timer? _t;

  @override
  void initState() {
    super.initState();
    // poll every 2 seconds
    _t = Timer.periodic(const Duration(seconds: 2), (_) {
      final st = Provider.of<AppState>(context, listen: false);
      st.pollRenderStatus(); // expected method in AppState; adapt if named differently
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    final job = st.currentJob;
    final status = job?.status ?? 'none';
    final progress = (job?.progress ?? 0.0).clamp(0.0, 1.0);
    final videoUrl = job?.videoUrl;

    return Scaffold(
      appBar: AppBar(title: const Text('Render Status')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(title: const Text('Status'), subtitle: Text(status)),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 12),
            if (videoUrl != null)
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/player', arguments: videoUrl),
                child: const Text('Open Video'),
              ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                st.clearJob();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job cleared')));
              },
              child: const Text('Clear Job'),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments;
    final url = (arg is String) ? arg : 'No URL';
    return Scaffold(appBar: AppBar(title: const Text('Player')), body: Center(child: Text('Play: $url')));
  }
}
