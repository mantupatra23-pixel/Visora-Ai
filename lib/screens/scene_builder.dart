// lib/screens/scene_builder.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/scene.dart'; // <-- यहीं तुम्हारे actual model path/name डालो

class SceneBuilderScreen extends StatefulWidget {
  const SceneBuilderScreen({super.key});

  @override
  State<SceneBuilderScreen> createState() => _SceneBuilderScreenState();
}

class _SceneBuilderScreenState extends State<SceneBuilderScreen> {
  // Local scenes list (editable) typed to SceneModel
  List<SceneModel> scenes = [];

  @override
  void initState() {
    super.initState();
    // load initial state from provider
    final st = WidgetsBinding.instance.platformDispatcher;
    // we'll populate in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final st = Provider.of<AppState>(context, listen: false);
    // ensure provider scenes are mapped to SceneModel instances
    final providerScenes = st.scenes;
    if (providerScenes.isNotEmpty) {
      scenes = providerScenes.map((s) => s).toList();
    } else {
      scenes = [];
    }
  }

  void _saveToState() {
    final st = Provider.of<AppState>(context, listen: false);
    st.setScenes(scenes);
  }

  void _addNewScene() {
    final newScene = SceneModel(
      name: 'Scene ${scenes.length + 1}',
      environment: 'room',
      camera: 'wide',
      motion: 'none',
    );
    setState(() {
      scenes.add(newScene);
    });
    _saveToState();
  }

  void _showEditDialog(int idx) {
    final s = scenes[idx];
    final env = TextEditingController(text: s.environment ?? '');
    final cam = TextEditingController(text: s.camera ?? '');
    final mot = TextEditingController(text: s.motion ?? '');
    final name = TextEditingController(text: s.name ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Scene'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: env, decoration: const InputDecoration(labelText: 'Environment')),
              TextField(controller: cam, decoration: const InputDecoration(labelText: 'Camera')),
              TextField(controller: mot, decoration: const InputDecoration(labelText: 'Motion')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  scenes[idx] = SceneModel(
                    name: name.text.trim().isEmpty ? 'Scene ${idx + 1}' : name.text.trim(),
                    environment: env.text.trim(),
                    camera: cam.text.trim(),
                    motion: mot.text.trim(),
                  );
                });
                _saveToState();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }

  void _duplicateScene(int idx) {
    final s = scenes[idx];
    final copy = SceneModel(
      name: '${s.name}_copy',
      environment: s.environment,
      camera: s.camera,
      motion: s.motion,
    );
    setState(() {
      scenes.insert(idx + 1, copy);
    });
    _saveToState();
  }

  void _deleteScene(int idx) {
    setState(() {
      scenes.removeAt(idx);
    });
    _saveToState();
  }

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    // ensure local scenes synced with provider when provider changes
    if (st.scenes.length != scenes.length) {
      scenes = st.scenes.map((s) => s).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scene Builder')),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: scenes.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final it = scenes.removeAt(oldIndex);
            scenes.insert(newIndex, it);
          });
          _saveToState();
        },
        itemBuilder: (context, idx) {
          final s = scenes[idx];
          return Card(
            key: ValueKey(s.name + idx.toString()),
            child: ListTile(
              title: Text(s.name ?? 'Scene ${idx + 1}'),
              subtitle: Text('${s.environment ?? ''} • ${s.camera ?? ''} • ${s.motion ?? ''}'),
              trailing: PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'duplicate') {
                    _duplicateScene(idx);
                  } else if (v == 'delete') {
                    _deleteScene(idx);
                  } else if (v == 'edit') {
                    _showEditDialog(idx);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewScene,
        icon: const Icon(Icons.add),
        label: const Text('Add Scene'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Save and go next
                  _saveToState();
                  Navigator.pushNamed(context, '/voice');
                },
                child: const Text('Next'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
