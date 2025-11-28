import 'package:flutter/material.dart';
import '../models/scene.dart';
import '../state/app_state.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Scenes")),
      body: Column(
        children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Scene Name")),
          TextField(controller: envCtrl, decoration: const InputDecoration(labelText: "Environment")),
          TextField(controller: cameraCtrl, decoration: const InputDecoration(labelText: "Camera")),
          TextField(controller: motionCtrl, decoration: const InputDecoration(labelText: "Motion")),

          ElevatedButton(
            onPressed: () {
              st.addScene(
                SceneModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameCtrl.text,
                  environment: envCtrl.text,
                  camera: cameraCtrl.text,
                  motion: motionCtrl.text,
                ),
              );
            },
            child: const Text("Add Scene"),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: st.scenes.length,
              itemBuilder: (_, i) {
                final s = st.scenes[i];
                return ListTile(
                  title: Text(s.name),
                  subtitle: Text("${s.environment} | ${s.camera} | ${s.motion}"),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
