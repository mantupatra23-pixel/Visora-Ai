import 'package:flutter/material.dart';
import 'dart:math';

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

  final List<Map<String, String>> _scenes = [];

  String _newId() {
    final t = DateTime.now().millisecondsSinceEpoch;
    final r = Random().nextInt(9999);
    return '$t$r';
  }

  void _addScene() {
    final name = nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scene name required')));
      return;
    }

    setState(() {
      _scenes.add({
        'id': _newId(),
        'name': name,
        'environment': envCtrl.text.trim(),
        'camera': cameraCtrl.text.trim(),
        'motion': motionCtrl.text.trim(),
      });
      nameCtrl.clear();
      envCtrl.clear();
      cameraCtrl.clear();
      motionCtrl.clear();
    });
  }

  void _removeScene(String id) {
    setState(() {
      _scenes.removeWhere((m) => m['id'] == id);
    });
  }

  void _editScene(String id) {
    final idx = _scenes.indexWhere((m) => m['id'] == id);
    if (idx == -1) return;

    nameCtrl.text = _scenes[idx]['name'] ?? '';
    envCtrl.text = _scenes[idx]['environment'] ?? '';
    cameraCtrl.text = _scenes[idx]['camera'] ?? '';
    motionCtrl.text = _scenes[idx]['motion'] ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Scene'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: envCtrl, decoration: const InputDecoration(labelText: 'Environment')),
            TextField(controller: cameraCtrl, decoration: const InputDecoration(labelText: 'Camera')),
            TextField(controller: motionCtrl, decoration: const InputDecoration(labelText: 'Motion')),
          ],
        ),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
            nameCtrl.clear(); envCtrl.clear(); cameraCtrl.clear(); motionCtrl.clear();
          }, child: const Text('Cancel')),
          ElevatedButton(onPressed: () {
            final name = nameCtrl.text.trim();
            if (name.isEmpty) return;
            setState(() {
              _scenes[idx] = {
                'id': id,
                'name': name,
                'environment': envCtrl.text.trim(),
                'camera': cameraCtrl.text.trim(),
                'motion': motionCtrl.text.trim(),
              };
            });
            nameCtrl.clear(); envCtrl.clear(); cameraCtrl.clear(); motionCtrl.clear();
            Navigator.pop(context);
          }, child: const Text('Save')),
        ],
      ),
    );
  }

  void _reorderScenes(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _scenes.removeAt(oldIndex);
      _scenes.insert(newIndex, item);
    });
  }

  void _done() {
    Navigator.pop(context, _scenes);
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scene Builder'),
        actions: [
          IconButton(icon: const Icon(Icons.check), tooltip: 'Done', onPressed: _done),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Input fields
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Scene Name')),
            const SizedBox(height: 8),
            TextField(controller: envCtrl, decoration: const InputDecoration(labelText: 'Environment')),
            const SizedBox(height: 8),
            TextField(controller: cameraCtrl, decoration: const InputDecoration(labelText: 'Camera')),
            const SizedBox(height: 8),
            TextField(controller: motionCtrl, decoration: const InputDecoration(labelText: 'Motion')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Scene'),
                    onPressed: _addScene,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Reorderable list
            Expanded(
              child: _scenes.isEmpty
                  ? const Center(child: Text('No scenes yet. Add one above.'))
                  : ReorderableListView.builder(
                      itemCount: _scenes.length,
                      onReorder: _reorderScenes,
                      buildDefaultDragHandles: true,
                      itemBuilder: (context, index) {
                        final s = _scenes[index];
                        return Card(
                          key: ValueKey(s['id']),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(s['name'] ?? ''),
                            subtitle: Text('Env: ${s['environment'] ?? '-'}  •  Camera: ${s['camera'] ?? '-'}  •  Motion: ${s['motion'] ?? '-'}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: const Icon(Icons.edit), onPressed: () => _editScene(s['id']!)),
                                IconButton(icon: const Icon(Icons.delete), onPressed: () => _removeScene(s['id']!)),
                                ReorderableDragStartListener(
                                  index: index,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(Icons.drag_handle),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
