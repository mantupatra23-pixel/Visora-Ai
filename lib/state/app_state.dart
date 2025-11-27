import 'package:flutter/foundation.dart';
import '../models/character.dart';
import '../models/scene.dart';
import '../models/scene_block.dart';
import '../models/render_job.dart';

class AppState extends ChangeNotifier {
  final ApiService api = ApiService(
    baseUrl: "https://visora-backend-v2.onrender.com",
  );

  // Script
  String script = "";
  void setScript(String value) {
    script = value;
    notifyListeners();
  }

  // Characters
  List<CharacterModel> characters = [];
  void setCharacters(List<CharacterModel> list) {
    characters = list;
    notifyListeners();
  }

  void addCharacter(CharacterModel c) {
    characters.add(c);
    notifyListeners();
  }

  // Scenes
  List<SceneModel> scenes = [];
  void setScenes(List<SceneModel> list) {
    scenes = list;
    notifyListeners();
  }

  // Render Job
  RenderJob? currentJob;

  void setJob(RenderJob job) {
    currentJob = job;
    notifyListeners();
  }

  void clearJob() {
    currentJob = null;
    notifyListeners();
  }

  // Start render job
  Future<void> startRenderJob() async {
    try {
      final body = {
        "script": script,
        "scenes": scenes.map((s) => s.toJson()).toList(),
        "characters": characters.map((c) => c.toJson()).toList(),
      };

      final result = await api.post("/render/create", body);
      setJob(RenderJob.fromJson(result));
    } catch (e) {
      debugPrint("Render job error: $e");
    }
  }

  // Poll status
  Future<void> pollRenderStatus() async {
    if (currentJob == null) return;
    try {
      final result = await api.get("/render/status?id=${currentJob!.id}");
      final updated = RenderJob.fromJson(result);
      setJob(updated);
    } catch (e) {
      debugPrint("Status poll error: $e");
    }
  }
}
