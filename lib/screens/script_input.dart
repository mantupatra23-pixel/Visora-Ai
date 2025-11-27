import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/character.dart';
import '../models/scene_block.dart';

class ScriptInputScreen extends StatefulWidget {
  const ScriptInputScreen({super.key});
  @override
  State<ScriptInputScreen> createState() => _ScriptInputScreenState();
}

class _ScriptInputScreenState extends State<ScriptInputScreen> {
  late TextEditingController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _autoDetect(AppState st) {
    final text = _ctrl.text.trim();
    final parts = text.split(RegExp(r'\n\s*\n')).where((p) => p.isNotEmpty).toList();
    final scenes = <SceneBlock>[];
    for (var i = 0; i < parts.length; i++) scenes.add(SceneBlock(name: 'Scene ${i+1}'));
    final chars = <Character>[];
    if (text.toLowerCase().contains('he') || text.toLowerCase().contains('she')) chars.add(Character(name: 'Lead'));
    else chars.add(Character(name: 'Narrator'));
    st.updateScript(text);
    st.setScenes(scenes);
    st.setCharacters(chars);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Auto-detection done (mock)')));
  }

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context);
    _ctrl.text = st.script;
    return Scaffold(
      appBar: AppBar(title: const Text('Script Input')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Expanded(child: TextField(controller: _ctrl, expands: true, maxLines: null, decoration: const InputDecoration(hintText: 'Paste script'))),
          Row(children: [
            ElevatedButton.icon(icon: const Icon(Icons.auto_mode), label: const Text('Auto Scene'), onPressed: () => _autoDetect(st)),
            const SizedBox(width: 8),
            ElevatedButton(child: const Text('Continue'), onPressed: () {
              st.updateScript(_ctrl.text);
              Navigator.pushNamed(context, '/characters');
            }),
          ])
        ]),
      ),
    );
  }
}
