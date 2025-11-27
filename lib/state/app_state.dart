// lib/state/app_state.dart
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/scene.dart';
import '../models/character.dart';
import '../models/render_job.dart';

class AppState extends ChangeNotifier {
  // Provide your backend base URL here or keep the one you used.
  final ApiService api = ApiService(baseUrl: 'https://visora-backend-v2.onrender.com');

  // Script text
  String script = '';

  void setScript(String value) {
    script = value;
    notifyListeners();
  }

  // Characters
  List<CharacterModel> characters = [];

  /// Accepts List<dynamic> and converts to List<CharacterModel>
  void setCharacters(List<dynamic> list) {
    characters = list.map<CharacterModel>((e) {
      if (e is CharacterModel) return e;
      if (e is Map) {
        return CharacterModel.fromJson(Map<String, dynamic>.from(e));
      }
      // Fallback: try to cast or create a minimal model
      try {
        final m = Map<String, dynamic>.from(e as Map);
        return CharacterModel.fromJson(m);
      } catch (_) {
        return CharacterModel(id: '', name: '', voice: 'default', outfit: 'default');
      }
    }).toList();
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

  // Start Render Job — creates job on backend and stores it
  Future<void> startRenderJob() async {
    try {
      final body = {
        'script': script,
        'scenes': scenes.map((s) => s.toJson()).toList(),
        'characters': characters.map((c) => c.toJson()).toList(),
      };

      final result = await api.post('/render/create', body);
      // assume result is a json map for the job
      setJob(RenderJob.fromJson(result));
    } catch (e) {
      debugPrint('Render job error: $e');
    }
  }

  // Poll status for current job (call periodically)
  Future<void> pollRenderStatus() async {
    if (currentJob == null) return;
    try {
      final result = await api.get('/render/status/${currentJob!.id}');
      final updated = RenderJob.fromJson(result);
      setJob(updated);
    } catch (e) {
      debugPrint('Status poll error: $e');
    }
  }
}
