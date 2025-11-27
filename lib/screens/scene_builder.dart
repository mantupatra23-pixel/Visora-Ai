import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/scene.dart';
import '../models/scene_block.dart';

class SceneBuilderScreen extends StatefulWidget {
  const SceneBuilderScreen({super.key});

  @override
  State<SceneBuilderScreen> createState() => _SceneBuilderScreenState();
}

class _SceneBuilderScreenState extends State<SceneBuilderScreen> {
  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    final scenes = st.scenes.isEmpty
        ? [
            SceneModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: 'Scene 1',
              environment: 'room',
              blocks: [],
            )
          ]
        : st.scenes;

    return Scaffold(
      appBar: AppBar(title: const Text('Scene Builder')),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: scenes.length,
        onReorder: (oldIdx, newIdx) {
          setState(() {
            if (newIdx > oldIdx) newIdx--;
            final it = scenes.removeAt(oldIdx);
            scenes.insert(newIdx, it);
            st.setScenes(List.from(scenes));
          });
        },
        itemBuilder: (context, idx) {
          final s = scenes[idx];
          return Card(
            key: ValueKey(s.id),
            child: ListTile(
              title: Text(s.name),
              subtitle: Text('Env: ${s.environment} • Blocks: ${s.blocks.length}'),
              trailing: PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'duplicate') {
                    final copy = SceneModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: '${s.name}_copy',
                      environment: s.environment,
                      blocks: s.blocks.map((b) => SceneBlock(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        environment: b.environment,
                        camera: b.camera,
                        motion: b.motion,
                        extra: b.extra != null ? Map.from(b.extra!) : null,
                      )).toList(),
                    );
                    setState(() {
                      scenes.insert(idx + 1, copy);
                      st.setScenes(List.from(scenes));
                    });
                  } else if (v == 'delete') {
                    setState(() {
                      scenes.removeAt(idx);
                      st.setScenes(List.from(scenes));
                    });
                  } else if (v == 'edit') {
                    final env = TextEditingController(text: s.environment);
                    final name = TextEditingController(text: s.name);
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Edit Scene'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
                            TextField(controller: env, decoration: const InputDecoration(labelText: 'Environment')),
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                s.name = name.text;
                                s.environment = env.text;
                                st.setScenes(List.from(scenes));
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final newScene = SceneModel(
            id: id,
            name: 'Scene ${scenes.length + 1}',
            environment: 'room',
            blocks: [],
          );
          setState(() {
            scenes.add(newScene);
            st.setScenes(List.from(scenes));
          });
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Done'),
        ),
      ),
    );
  }
}
