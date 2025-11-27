import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/render_job.dart';
import '../models/scene.dart';
import '../models/character.dart';

class AppState extends ChangeNotifier {
  // -----------------------------------------------------------
  // Backend API service instance
  // -----------------------------------------------------------
  final ApiService api = ApiService(baseUrl: "https://visora-backend-v2.onrender.com");

  // -----------------------------------------------------------
  // Project data
  // -----------------------------------------------------------
  List<SceneModel> scenes = [];
  List<CharacterModel> characters = [];

  // -----------------------------------------------------------
  // Render job
  // -----------------------------------------------------------
  RenderJob? currentJob;

  // -----------------------------------------------------------
  // Set Scenes
  // -----------------------------------------------------------
  void setScenes(List<SceneModel> list) {
    scenes = list;
    notifyListeners();
  }

  // -----------------------------------------------------------
  // Add Character
  // -----------------------------------------------------------
  void addCharacter(CharacterModel c) {
    characters.add(c);
    notifyListeners();
  }

  // -----------------------------------------------------------
  // Set Job
  // -----------------------------------------------------------
  void setJob(RenderJob job) {
    currentJob = job;
    notifyListeners();
  }

  // -----------------------------------------------------------
  // Clear job
  // -----------------------------------------------------------
  void clearJob() {
    currentJob = null;
    notifyListeners();
  }

  // -----------------------------------------------------------
  // Start Render Job
  // -----------------------------------------------------------
  Future<void> startRenderJob() async {
    try {
      final data = {
        "scenes": scenes.map((s) => s.toJson()).toList(),
        "characters": characters.map((c) => c.toJson()).toList(),
      };

      final result = await api.post("/render/create", data);

      setJob(RenderJob.fromJson(result));
    } catch (e) {
      debugPrint("Render job error: $e");
    }
  }

  // -----------------------------------------------------------
  // Poll job status
  // -----------------------------------------------------------
  Future<void> pollRenderStatus() async {
    if (currentJob == null) return;

    try {
      final result = await api.get("/render/status?jobId=${currentJob!.jobId}");
      final updated = RenderJob.fromJson(result);
      setJob(updated);
    } catch (e) {
      debugPrint("Status poll error: $e");
    }
  }
}
