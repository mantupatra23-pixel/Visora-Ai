import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
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
    final scenes = st.scenes.isEmpty ? [SceneBlock(name: 'Scene 1')] : st.scenes;
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
            st.setScenes(scenes);
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
                  if (v == 'duplicate') { setState((){ scenes.insert(idx+1, SceneBlock(name: '${s.name} copy', environment: s.environment, camera: s.camera, motion: s.motion)); st.setScenes(scenes); }); }
                  else if (v == 'delete') { setState((){ scenes.removeAt(idx); st.setScenes(scenes); }); }
                  else if (v == 'edit') {
                    final env = TextEditingController(text: s.environment);
                    final cam = TextEditingController(text: s.camera);
                    final mot = TextEditingController(text: s.motion);
                    showDialog(context: context, builder: (_){
                      return AlertDialog(title: const Text('Edit Scene'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: env, decoration: const InputDecoration(labelText: 'Environment')), TextField(controller: cam, decoration: const InputDecoration(labelText: 'Camera')), TextField(controller: mot, decoration: const InputDecoration(labelText: 'Motion'))]), actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Cancel')), ElevatedButton(onPressed: (){ setState((){ s.environment = env.text; s.camera = cam.text; s.motion = mot.text; st.setScenes(scenes); }); Navigator.pop(context); }, child: const Text('Save'))],);
                    });
                  }
                },
                itemBuilder: (context) => [ const PopupMenuItem(value: 'edit', child: Text('Edit')), const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')), const PopupMenuItem(value: 'delete', child: Text('Delete')) ],
              )),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () { setState(() { scenes.add(SceneBlock(name: 'Scene ${scenes.length+1}')); st.setScenes(scenes); }); }, icon: const Icon(Icons.add), label: const Text('Add Scene')),
      bottomNavigationBar: Padding(padding: const EdgeInsets.all(8), child: ElevatedButton(child: const Text('Next: Voice & Lipsync'), onPressed: () => Navigator.pushNamed(context, '/voice'))),
    );
  }
}
