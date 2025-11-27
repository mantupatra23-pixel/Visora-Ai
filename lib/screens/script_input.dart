import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/character.dart';
import '../models/scene.dart';

class ScriptInputScreen extends StatefulWidget {
  const ScriptInputScreen({super.key});

  @override
  State<ScriptInputScreen> createState() => _ScriptInputScreenState();
}

class _ScriptInputScreenState extends State<ScriptInputScreen> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Enter Script")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _ctrl,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: "Script text",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Detect Characters & Continue"),
              onPressed: () {
                final text = _ctrl.text.trim();
                st.setScript(text);

                List<CharacterModel> chars = [];

                if (text.toLowerCase().contains("he") ||
                    text.toLowerCase().contains("hero")) {
                  chars.add(CharacterModel(
                      id: "1", name: "Hero", voice: "default", outfit: "default"));
                }
                if (text.toLowerCase().contains("she") ||
                    text.toLowerCase().contains("girl")) {
                  chars.add(CharacterModel(
                      id: "2", name: "Heroine", voice: "female", outfit: "default"));
                }

                // Default narrator
                chars.add(CharacterModel(
                    id: "n1", name: "Narrator", voice: "calm", outfit: "none"));

                st.setCharacters(chars);

                // Default scenes
                st.setScenes([
                  SceneModel(
                      name: "Scene 1",
                      environment: "room",
                      camera: "wide",
                      motion: "none")
                ]);

                Navigator.pushNamed(context, "/characters");
              },
            )
          ],
        ),
      ),
    );
  }
}
