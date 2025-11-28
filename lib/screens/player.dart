import 'package:flutter/foundation.dart';
import 'package:visora_ai/services/api_service.dart';
import 'package:visora_ai/models/scene.dart';
import 'package:visora_ai/models/character.dart';
import 'package:visora_ai/models/render_job.dart';

class AppState extends ChangeNotifier {
  final ApiService api;

  AppState({required this.api});

  // ---------------------------
  // Script
  // ---------------------------
  String _script = "";
  String get script => _script;
  void setScript(String value) {
    _script = value;
    notifyListeners();
  }

  // ---------------------------
  // Characters
  // ---------------------------
  final List<CharacterModel> _characters = [];
  List<CharacterModel> get characters => List.unmodifiable(_characters);

  void setCharacters(List<CharacterModel> list) {
    _characters
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  void addCharacter(CharacterModel c) {
    _characters.add(c);
    notifyListeners();
  }

  void removeCharacterAt(int idx) {
    if (idx >= 0 && idx < _characters.length) {
      _characters.removeAt(idx);
      notifyListeners();
    }
  }

  // ---------------------------
  // Scenes
  // ---------------------------
  final List<SceneModel> _scenes = [];
  List<SceneModel> get scenes => List.unmodifiable(_scenes);

  void setScenes(List<SceneModel> list) {
    _scenes
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  void addScene(SceneModel s) {
    _scenes.add(s);
    notifyListeners();
  }

  void removeSceneAt(int idx) {
    if (idx >= 0 && idx < _scenes.length) {
      _scenes.removeAt(idx);
      notifyListeners();
    }
  }

  void reorderScenes(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= _scenes.length) return;
    if (newIndex < 0 || newIndex > _scenes.length) return;
    if (newIndex > oldIndex) newIndex--;
    final it = _scenes.removeAt(oldIndex);
    _scenes.insert(newIndex, it);
    notifyListeners();
  }

  // ---------------------------
  // Render job
  // ---------------------------
  RenderJob? _currentJob;
  RenderJob? get currentJob => _currentJob;

  void setJob(RenderJob job) {
    _currentJob = job;
    notifyListeners();
  }

  void clearJob() {
    _currentJob = null;
    notifyListeners();
  }

  // ---------------------------
  // Start create video job on backend
  // returns job id or throws
  // ---------------------------
  Future<String> startCreateJob() async {
    final body = {
      "script": _script,
      "scenes": _scenes.map((s) => s.toJson()).toList(),
      "characters": _characters.map((c) => c.toJson()).toList(),
    };

    final result = await api.post('/create-video', body);
    // expected backend returns something like { "job_id": "abc123" }
    if (result is Map && (result['job_id'] ?? result['id']) != null) {
      final id = result['job_id'] ?? result['id'];
      return id.toString();
    }
    // fallback: if backend returns full job object
    if (result is Map && result['job'] != null) {
      final jobJson = result['job'];
      final job = RenderJob.fromJson(jobJson);
      setJob(job);
      return job.id ?? '';
    }
    throw Exception('Invalid create-job response: $result');
  }

  /// Call backend to start rendering (put in queue)
  Future<void> startRender(String jobId) async {
    // backend route example: GET /render/start/{job_id}
    await api.get('/render/start/$jobId');
  }

  /// Poll status from backend and update current job
  Future<void> pollRenderStatus() async {
    if (_currentJob == null || _currentJob!.id == null) return;
    try {
      final result = await api.get('/job/${_currentJob!.id}');
      // expected to return job json
      if (result is Map) {
        final updated = RenderJob.fromJson(result);
        _currentJob = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('pollRenderStatus error: $e');
    }
  }
}
