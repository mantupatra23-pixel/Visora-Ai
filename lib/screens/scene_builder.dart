import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/scene.dart';

class SceneBuilderScreen extends StatefulWidget {
  const SceneBuilderScreen({super.key});
  @override
  State<SceneBuilderScreen> createState() => _SceneBuilderScreenState();
}

class _SceneBuilderScreenState extends State<SceneBuilderScreen> {
  final nameCtrl = TextEditingController();
  final envCtrl = TextEditingController();
  final cameraCtrl = TextEditingController();
  final motionCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    envCtrl.dispose();
    cameraCtrl.dispose();
    motionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Scenes')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Scene name')),
          TextField(controller: envCtrl, decoration: const InputDecoration(labelText: 'Environment')),
          TextField(controller: cameraCtrl, decoration: const InputDecoration(labelText: 'Camera (wide/close)')),
          TextField(controller: motionCtrl, decoration: const InputDecoration(labelText: 'Motion')),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              final s = SceneModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameCtrl.text,
                environment: envCtrl.text,
                camera: cameraCtrl.text.isEmpty ? 'wide' : cameraCtrl.text,
                motion: motionCtrl.text.isEmpty ? 'none' : motionCtrl.text,
              );
              st.addScene(s.toJson());
              nameCtrl.clear();
              envCtrl.clear();
              cameraCtrl.clear();
              motionCtrl.clear();
            },
            child: const Text('Add Scene'),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: st.scenes.length,
              itemBuilder: (_, i) {
                final s = st.scenes[i];
                return ListTile(
                  title: Text(s['name'] ?? 'Scene'),
                  subtitle: Text('${s['environment'] ?? ''} • ${s['camera'] ?? ''}'),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
