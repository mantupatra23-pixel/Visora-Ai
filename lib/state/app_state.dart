// lib/state/app_state.dart
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/scene.dart';
import '../models/character.dart';
import '../models/render_job.dart';

class AppState extends ChangeNotifier {
  final ApiService api;

  // constructor: ApiService required
  AppState({required this.api});

  // Script text
  String script = "";

  void setScript(String value) {
    script = value;
    notifyListeners();
  }

  // Characters
  List<CharacterModel> characters = [];
  void setCharacters(List<CharacterModel> list) {
    characters = List<CharacterModel>.from(list);
    notifyListeners();
  }

  void addCharacter(CharacterModel c) {
    characters.add(c);
    notifyListeners();
  }

  // Scenes
  List<SceneModel> scenes = [];
  void setScenes(List<SceneModel> list) {
    scenes = List<SceneModel>.from(list);
    notifyListeners();
  }

  void addScene(SceneModel s) {
    scenes.add(s);
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

  // Start Render Job: create project -> start render -> setJob
  Future<void> startRenderJob() async {
    try {
      final body = {
        'script': script,
        'scenes': scenes.map((s) => s.toJson()).toList(),
        'characters': characters.map((c) => c.toJson()).toList(),
      };

      // 1) create project on backend
      final projectResp = await api.createProject(body);
      // projectResp must contain projectId (backend dependent)
      final projectId = projectResp['projectId'] ?? projectResp['id'] ?? projectResp['data']?['id'];

      if (projectId == null) {
        throw Exception('Invalid project id returned from backend');
      }

      // 2) start render
      final startResp = await api.startRender(projectId.toString());

      // 3) Parse returned job (assume backend returns job data)
      // RenderJob.fromJson should handle response structure
      final job = RenderJob.fromJson(startResp);
      setJob(job);
    } catch (e) {
      debugPrint('Render job error: $e');
      rethrow;
    }
  }

  // Poll status
  Future<void> pollRenderStatus() async {
    if (currentJob == null) return;
    try {
      final result = await api.get('/render/status', queryParameters: {'jobId': currentJob!.id});
      final updated = RenderJob.fromJson(result);
      setJob(updated);
    } catch (e) {
      debugPrint('Status poll error: $e');
    }
  }
}
