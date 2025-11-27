// lib/state/app_state.dart
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/scene.dart';
import '../models/character.dart';
import '../models/render_job.dart';

class AppState extends ChangeNotifier {
  // ---- API ----
  final ApiService api =
      ApiService(baseUrl: 'https://visora-backend-v2.onrender.com');

  // ---- Script text ----
  String script = '';

  void setScript(String value) {
    script = value;
    notifyListeners();
  }

  // ---- Characters ----
  List<CharacterModel> characters = [];

  void setCharacters(List<CharacterModel> list) {
    characters = List<CharacterModel>.from(list);
    notifyListeners();
  }

  void addCharacter(CharacterModel c) {
    characters.add(c);
    notifyListeners();
  }

  void removeCharacterAt(int index) {
    if (index >= 0 && index < characters.length) {
      characters.removeAt(index);
      notifyListeners();
    }
  }

  // ---- Scenes ----
  List<SceneModel> scenes = [];

  void setScenes(List<SceneModel> list) {
    scenes = List<SceneModel>.from(list);
    notifyListeners();
  }

  void addScene(SceneModel s) {
    scenes.add(s);
    notifyListeners();
  }

  void removeSceneAt(int index) {
    if (index >= 0 && index < scenes.length) {
      scenes.removeAt(index);
      notifyListeners();
    }
  }

  // ---- Render Job ----
  RenderJob? currentJob;

  void setJob(RenderJob job) {
    currentJob = job;
    notifyListeners();
  }

  void clearJob() {
    currentJob = null;
    notifyListeners();
  }

  // ---- Start Render Job (POST to backend) ----
  Future<void> startRenderJob() async {
    try {
      // Build request body
      final body = <String, dynamic>{
        'script': script,
        'scenes': scenes.map((s) => s.toJson()).toList(),
        'characters': characters.map((c) => c.toJson()).toList(),
      };

      // Call backend endpoint (adjust path if endpoint is different)
      final result = await api.post('/render/create', body);

      // Expect result to be a JSON map for created job
      if (result is Map<String, dynamic>) {
        setJob(RenderJob.fromJson(result));
      } else {
        // If backend wraps data under a field e.g. {"data": {...}}
        if (result is Map && result['data'] is Map<String, dynamic>) {
          setJob(RenderJob.fromJson(result['data'] as Map<String, dynamic>));
        } else {
          debugPrint('Unexpected response from startRenderJob: $result');
        }
      }
    } catch (e, st) {
      debugPrint('Render job error: $e\n$st');
    }
  }

  // ---- Poll render status (GET) ----
  Future<void> pollRenderStatus() async {
    if (currentJob == null) return;

    try {
      // Adjust path to match your backend route (example used /render/status/:id)
      final path = '/render/status/${currentJob!.id}';
      final result = await api.get(path);

      if (result is Map<String, dynamic>) {
        final updated = RenderJob.fromJson(result);
        setJob(updated);
      } else if (result is Map && result['data'] is Map<String, dynamic>) {
        final updated = RenderJob.fromJson(result['data'] as Map<String, dynamic>);
        setJob(updated);
      } else {
        debugPrint('Unexpected poll response: $result');
      }
    } catch (e, st) {
      debugPrint('Status poll error: $e\n$st');
    }
  }
}
