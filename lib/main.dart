// main.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

/// Replace with your backend base URL
const String backendBase = 'https://visora-backend-v2.onrender.com';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => VisoraState(),
      child: const VisoraApp(),
    ),
  );
}

/* -------------------------
   App State (provider)
   ------------------------- */
class VisoraState extends ChangeNotifier {
  String script = '';
  List<Character> characters = [];
  List<SceneBlock> scenes = [];
  RenderJob? currentJob;

  void updateScript(String s) {
    script = s;
    notifyListeners();
  }

  void setCharacters(List<Character> list) {
    characters = list;
    notifyListeners();
  }

  void setScenes(List<SceneBlock> list) {
    scenes = list;
    notifyListeners();
  }

  void setJob(RenderJob job) {
    currentJob = job;
    notifyListeners();
  }

  void clearJob() {
    currentJob = null;
    notifyListeners();
  }
}

/* -------------------------
   Simple Models
   ------------------------- */
class Character {
  String name;
  String voice;
  String outfit;
  Character({required this.name, this.voice = 'Neutral', this.outfit = 'Default'});
}

class SceneBlock {
  String name;
  String environment;
  String camera;
  String motion;
  SceneBlock({
    required this.name,
    this.environment = 'Room',
    this.camera = 'Mid-shot',
    this.motion = 'Smooth',
  });
}

class RenderJob {
  final String id;
  String status;
  double progress;
  RenderJob({required this.id, this.status = 'queued', this.progress = 0});
}

/* -------------------------
   API Service (very small)
   ------------------------- */
class VisoraApi {
  final String base;
  VisoraApi({required this.base});

  Future<Map<String, dynamic>> createProject({
    required String script,
    required List<Character> characters,
    required List<SceneBlock> scenes,
    Map<String, dynamic>? renderSettings,
  }) async {
    final uri = Uri.parse('$base/create_project');
    final body = {
      'script': script,
      'characters': characters.map((c) => {'name': c.name, 'voice': c.voice, 'outfit': c.outfit}).toList(),
      'scenes': scenes.map((s) => {'name': s.name, 'env': s.environment, 'camera': s.camera, 'motion': s.motion}).toList(),
      'renderSettings': renderSettings ?? {},
    };

    final r = await http.post(uri, body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (r.statusCode >= 200 && r.statusCode < 300) {
      return jsonDecode(r.body);
    } else {
      throw Exception('Create project failed: ${r.statusCode} ${r.body}');
    }
  }

  Future<Map<String, dynamic>> startRender(String projectId) async {
    final uri = Uri.parse('$base/projects/$projectId/start_render');
    final r = await http.post(uri, headers: {'Content-Type': 'application/json'});
    if (r.statusCode >= 200 && r.statusCode < 300) return jsonDecode(r.body);
    throw Exception('Start render failed: ${r.statusCode} ${r.body}');
  }

  Future<Map<String, dynamic>> getStatus(String jobId) async {
    final uri = Uri.parse('$base/job/$jobId/status');
    final r = await http.get(uri);
    if (r.statusCode >= 200 && r.statusCode < 300) return jsonDecode(r.body);
    throw Exception('Status failed: ${r.statusCode}');
  }

  Future<String> uploadAsset(File file) async {
    // simplified placeholder - your backend may require multipart upload
    final uri = Uri.parse('$base/upload');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final decoded = jsonDecode(res.body);
      return decoded['path'] ?? '';
    } else {
      throw Exception('Upload failed ${res.statusCode}');
    }
  }
}

/* -------------------------
   App Theme
   ------------------------- */
final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.deepPurple,
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

/* -------------------------
   Main App
   ------------------------- */
class VisoraApp extends StatelessWidget {
  const VisoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visora AI - Demo',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/script': (_) => const ScriptInputScreen(),
        '/characters': (_) => const CharacterScreen(),
        '/scenes': (_) => const SceneBuilderScreen(),
        '/voice': (_) => const VoiceLipsyncScreen(),
        '/render': (_) => const RenderSettingsScreen(),
        '/status': (_) => const RenderStatusScreen(),
        '/player': (_) => const VideoPlayerScreen(),
      },
    );
  }
}

/* -------------------------
   Home Screen
   ------------------------- */
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<VisoraState>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Visora AI')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.video_call),
              label: const Text('Create Video'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: () => Navigator.pushNamed(context, '/script'),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Recent renders'),
              subtitle: Text(state.currentJob?.id ?? 'No recent job'),
              trailing: state.currentJob != null
                  ? TextButton(
                      child: const Text('Status'),
                      onPressed: () => Navigator.pushNamed(context, '/status'),
                    )
                  : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text('Draft scripts'),
              subtitle: Text(state.script.isEmpty ? 'No draft' : state.script.substring(0, state.script.length.clamp(0, 40))),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile & Settings'),
              onTap: () {},
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.movie, size: 80, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Your renders will appear here'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/* -------------------------
   Script Input Screen
   ------------------------- */
class ScriptInputScreen extends StatefulWidget {
  const ScriptInputScreen({super.key});
  @override
  State<ScriptInputScreen> createState() => _ScriptInputScreenState();
}

class _ScriptInputScreenState extends State<ScriptInputScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _autoDetectScenes(VisoraState state) {
    // Very simple parser mock: split by blank lines -> scene blocks
    final text = _ctrl.text.trim();
    final parts = text.split(RegExp(r'\n\s*\n')).where((p) => p.trim().isNotEmpty).toList();
    final scenes = <SceneBlock>[];
    for (var i = 0; i < parts.length; i++) {
      scenes.add(SceneBlock(name: 'Scene ${i + 1}', environment: 'Room', camera: 'Mid-shot', motion: 'Smooth'));
    }
    // simple character detection mock
    final chars = <Character>[];
    if (text.toLowerCase().contains('he') || text.toLowerCase().contains('she')) {
      chars.add(Character(name: 'Protagonist'));
    } else {
      chars.add(Character(name: 'Narrator'));
    }
    state.updateScript(text);
    state.setScenes(scenes);
    state.setCharacters(chars);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Auto-detected scenes & characters (mock)')));
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<VisoraState>(context, listen: false);
    _ctrl.text = state.script;
    return Scaffold(
      appBar: AppBar(title: const Text('Script Input')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(hintText: 'Paste your script here (Hindi/English supported)'),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.auto_mode),
                  label: const Text('Auto Scene Detection'),
                  onPressed: () {
                    _autoDetectScenes(state);
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: const Text('Continue'),
                  onPressed: () {
                    state.updateScript(_ctrl.text);
                    Navigator.pushNamed(context, '/characters');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

/* -------------------------
   Character Customization
   ------------------------- */
class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});
  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<VisoraState>(context);
    final chars = state.characters.isEmpty ? [Character(name: 'Hero'), Character(name: 'Villain')] : state.characters;
    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: chars.length + 1,
        itemBuilder: (context, i) {
          if (i == chars.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add New Character'),
                onPressed: () {
                  setState(() {
                    chars.add(Character(name: 'New ${chars.length + 1}'));
                    state.setCharacters(chars);
                  });
                },
              ),
            );
          }
          final c = chars[i];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                TextFormField(initialValue: c.name, decoration: const InputDecoration(labelText: 'Name'), onChanged: (v) {
                  c.name = v;
                  state.setCharacters(chars);
                }),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: c.voice,
                      items: ['Neutral', 'Male', 'Female', 'Kid', 'Elder'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) {
                        if (v != null) {
                          c.voice = v;
                          state.setCharacters(chars);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Voice'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: c.outfit,
                      items: ['Default', 'Casual', 'Formal', 'Sport'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) {
                        if (v != null) {
                          c.outfit = v;
                          state.setCharacters(chars);
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Outfit'),
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {
                      setState(() {
                        chars.removeAt(i);
                        state.setCharacters(chars);
                      });
                    }, child: const Text('Delete')),
                  ],
                )
              ]),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: const Text('Next: Scene Builder'),
          onPressed: () => Navigator.pushNamed(context, '/scenes'),
        ),
      ),
    );
  }
}

/* -------------------------
   Scene Builder
   ------------------------- */
class SceneBuilderScreen extends StatefulWidget {
  const SceneBuilderScreen({super.key});
  @override
  State<SceneBuilderScreen> createState() => _SceneBuilderScreenState();
}

class _SceneBuilderScreenState extends State<SceneBuilderScreen> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<VisoraState>(context);
    final scenes = state.scenes.isEmpty ? [SceneBlock(name: 'Scene 1')] : state.scenes;
    return Scaffold(
      appBar: AppBar(title: const Text('Scene Builder')),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: scenes.length,
        onReorder: (oldIdx, newIdx) {
          setState(() {
            if (newIdx > oldIdx) newIdx--;
            final item = scenes.removeAt(oldIdx);
            scenes.insert(newIdx, item);
            state.setScenes(scenes);
          });
        },
        itemBuilder: (context, idx) {
          final s = scenes[idx];
          return Card(
            key: ValueKey(s.name + idx.toString()),
            child: ListTile(
              title: Text(s.name),
              subtitle: Text('${s.environment} • ${s.camera} • ${s.motion}'),
              trailing: PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'duplicate') {
                    setState(() {
                      final copy = SceneBlock(name: '${s.name} copy', environment: s.environment, camera: s.camera, motion: s.motion);
                      scenes.insert(idx + 1, copy);
                      state.setScenes(scenes);
                    });
                  } else if (v == 'delete') {
                    setState(() {
                      scenes.removeAt(idx);
                      state.setScenes(scenes);
                    });
                  } else if (v == 'edit') {
                    // open edit dialog
                    showDialog(
                      context: context,
                      builder: (_) {
                        final envCtrl = TextEditingController(text: s.environment);
                        final cameraCtrl = TextEditingController(text: s.camera);
                        final motionCtrl = TextEditingController(text: s.motion);
                        return AlertDialog(
                          title: const Text('Edit Scene'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(controller: envCtrl, decoration: const InputDecoration(labelText: 'Environment')),
                              TextField(controller: cameraCtrl, decoration: const InputDecoration(labelText: 'Camera')),
                              TextField(controller: motionCtrl, decoration: const InputDecoration(labelText: 'Motion')),
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                            ElevatedButton(onPressed: () {
                              setState(() {
                                s.environment = envCtrl.text;
                                s.camera = cameraCtrl.text;
                                s.motion = motionCtrl.text;
                                state.setScenes(scenes);
                              });
                              Navigator.pop(context);
                            }, child: const Text('Save')),
                          ],
                        );
                      },
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            final newScene = SceneBlock(name: 'Scene ${scenes.length + 1}');
            scenes.add(newScene);
            state.setScenes(scenes);
          });
        },
        label: const Text('Add Scene'),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: const Text('Next: Voice & Lipsync'),
          onPressed: () => Navigator.pushNamed(context, '/voice'),
        ),
      ),
    );
  }
}

/* -------------------------
   Voice & Lipsync
   ------------------------- */
class VoiceLipsyncScreen extends StatefulWidget {
  const VoiceLipsyncScreen({super.key});
  @override
  State<VoiceLipsyncScreen> createState() => _VoiceLipsyncScreenState();
}

class _VoiceLipsyncScreenState extends State<VoiceLipsyncScreen> {
  String voiceType = 'Neutral';
  String lipsync = 'Neutral fast';
  bool noiseReduction = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice & Lipsync')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          DropdownButtonFormField<String>(
            value: voiceType,
            items: ['Neutral', 'Male', 'Female', 'Kid', 'Elder'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => voiceType = v ?? voiceType),
            decoration: const InputDecoration(labelText: 'Voice selection'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: lipsync,
            items: ['Neutral fast', 'Emotional', 'Exaggerated'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => lipsync = v ?? lipsync),
            decoration: const InputDecoration(labelText: 'Lipsync profile'),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Background noise reduction'),
            value: noiseReduction,
            onChanged: (v) => setState(() => noiseReduction = v),
          ),
          const Spacer(),
          ElevatedButton(
            child: const Text('Next: Render Settings'),
            onPressed: () => Navigator.pushNamed(context, '/render'),
          )
        ]),
      ),
    );
  }
}

/* -------------------------
   Render Settings
   ------------------------- */
class RenderSettingsScreen extends StatefulWidget {
  const RenderSettingsScreen({super.key});
  @override
  State<RenderSettingsScreen> createState() => _RenderSettingsScreenState();
}

class _RenderSettingsScreenState extends State<RenderSettingsScreen> {
  String resolution = '1080p';
  String style = 'Realistic';
  int fps = 30;
  String output = 'Horizontal';
  bool ultra = false;

  bool _isRendering = false;

  final api = VisoraApi(base: backendBase);

  Future<void> _startRender(BuildContext ctx) async {
    final state = Provider.of<VisoraState>(ctx, listen: false);
    setState(() => _isRendering = true);

    try {
      // create project
      final project = await api.createProject(
        script: state.script,
        characters: state.characters,
        scenes: state.scenes,
        renderSettings: {
          'resolution': resolution,
          'style': style,
          'fps': fps,
          'output': output,
          'ultra': ultra,
        },
      );

      final projectId = project['projectId'] ?? project['id'] ?? 'proj-${DateTime.now().millisecondsSinceEpoch}';

      // start render
      final start = await api.startRender(projectId);
      final jobId = start['jobId'] ?? start['id'] ?? 'job-${DateTime.now().millisecondsSinceEpoch}';

      final job = RenderJob(id: jobId, status: 'started', progress: 0);
      state.setJob(job);

      // go to status screen
      Navigator.pushReplacementNamed(ctx, '/status');
    } catch (e, st) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Render failed: $e')));
    } finally {
      if (mounted) setState(() => _isRendering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Render Settings')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          DropdownButtonFormField<String>(
            value: resolution,
            items: ['1080p', '2K', '4K'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => resolution = v ?? resolution),
            decoration: const InputDecoration(labelText: 'Resolution'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: style,
            items: ['Realistic', 'Cinematic', 'Cartoon', 'Anime', 'Pixar-style'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => style = v ?? style),
            decoration: const InputDecoration(labelText: 'Style'),
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Text('FPS:'),
            const SizedBox(width: 8),
            DropdownButton<int>(value: fps, items: [24, 30, 60].map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(), onChanged: (v) => setState(() => fps = v ?? fps)),
            const Spacer(),
            const Text('Ultra GPU Mode'),
            Switch(value: ultra, onChanged: (v) => setState(() => ultra = v)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            const Text('Output:'),
            const SizedBox(width: 12),
            ChoiceChip(selected: output == 'Horizontal', label: const Text('Horizontal'), onSelected: (s) => setState(() => output = 'Horizontal')),
            const SizedBox(width: 8),
            ChoiceChip(selected: output == 'Vertical', label: const Text('Vertical'), onSelected: (s) => setState(() => output = 'Vertical')),
          ]),
          const Spacer(),
          ElevatedButton(
            child: _isRendering ? const Text('Starting...') : const Text('Generate Video'),
            onPressed: _isRendering ? null : () => _startRender(context),
          )
        ]),
      ),
    );
  }
}

/* -------------------------
   Render Status Screen
   ------------------------- */
class RenderStatusScreen extends StatefulWidget {
  const RenderStatusScreen({super.key});
  @override
  State<RenderStatusScreen> createState() => _RenderStatusScreenState();
}

class _RenderStatusScreenState extends State<RenderStatusScreen> {
  final api = VisoraApi(base: backendBase);
  bool polling = true;

  @override
  void initState() {
    super.initState();
    _poll();
  }

  @override
  void dispose() {
    polling = false;
    super.dispose();
  }

  void _poll() async {
    final state = Provider.of<VisoraState>(context, listen: false);
    while (polling) {
      final job = state.currentJob;
      if (job == null) break;
      try {
        final status = await api.getStatus(job.id);
        job.status = status['status'] ?? job.status;
        job.progress = (status['progress'] ?? job.progress).toDouble();
        state.notifyListeners();
        if (job.status == 'done' || job.status == 'failed') break;
      } catch (_) {
        // ignore errors when polling
      }
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<VisoraState>(context);
    final job = state.currentJob;
    return Scaffold(
      appBar: AppBar(title: const Text('Render Status')),
      body: job == null
          ? const Center(child: Text('No active job'))
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(children: [
                Text('Job ID: ${job.id}'),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: job.progress / 100.0),
                const SizedBox(height: 8),
                Text('Status: ${job.status} • ${job.progress.toStringAsFixed(0)}%'),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: const [
                      ListTile(title: Text('Script parsing'), subtitle: Text('Done')),
                      ListTile(title: Text('Character engine'), subtitle: Text('Processing')),
                      ListTile(title: Text('Lipsync'), subtitle: Text('Queued')),
                      ListTile(title: Text('Physics'), subtitle: Text('Queued')),
                      ListTile(title: Text('Sound'), subtitle: Text('Queued')),
                    ],
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: job.status == 'done' ? () => Navigator.pushNamed(context, '/player') : null,
                      child: const Text('Open Player'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        polling = false;
                        state.clearJob();
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                      child: const Text('Cancel Render'),
                    )
                  ],
                ),
              ]),
            ),
    );
  }
}

/* -------------------------
   Video Player + Download (placeholder)
   ------------------------- */
class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // placeholder: integrate video_player or better player plugin
    return Scaffold(
      appBar: AppBar(title: const Text('Player')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 320,
            height: 180,
            color: Colors.black12,
            child: const Center(child: Icon(Icons.play_circle_outline, size: 64)),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text('Download MP4'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download stub - implement real link')));
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('Share'),
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
            child: const Text('Create New Video'),
          )
        ]),
      ),
    );
  }
}
