import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/scene.dart';
import '../models/character.dart';
import '../models/render_job.dart';

class AppState extends ChangeNotifier {
  final ApiService api;

  // constructor
  AppState({required this.api});

  // script
  String script = '';
  void setScript(String v) { script = v; notifyListeners(); }

  // characters
  List<CharacterModel> characters = [];
  void setCharacters(List<CharacterModel> list) { characters = list; notifyListeners(); }
  void addCharacter(CharacterModel c) { characters.add(c); notifyListeners(); }

  // scenes
  List<SceneModel> scenes = [];
  void setScenes(List<SceneModel> list) { scenes = list; notifyListeners(); }
  void addScene(SceneModel s) { scenes.add(s); notifyListeners(); }

  // job
  RenderJob? currentJob;
  void setJob(RenderJob job) { currentJob = job; notifyListeners(); }
  void clearJob() { currentJob = null; notifyListeners(); }

  // create video job (calls backend)
  Future<String?> createProject() async {
    final body = {
      'script': script,
      'scenes': scenes.map((s) => s.toJson()).toList(),
      'characters': characters.map((c) => c.toJson()).toList(),
    };
    try {
      final res = await api.createVideo(body);
      final jobId = res['job_id'] ?? res['id'] ?? res['jobId'];
      return jobId?.toString();
    } catch (e) {
      debugPrint('createProject error: $e');
      return null;
    }
  }

  // start render
  Future<bool> startRenderJob(String jobId) async {
    try {
      await api.startRender(jobId);
      setJob(RenderJob(id: jobId, status: 'queued', progress: 0));
      return true;
    } catch (e) {
      debugPrint('startRender error: $e');
      return false;
    }
  }

  // poll status
  Future<void> pollStatus() async {
    if (currentJob == null) return;
    try {
      final res = await api.getJob(currentJob!.id);
      final updated = RenderJob.fromJson(res);
      setJob(updated);
    } catch (e) {
      debugPrint('pollStatus error: $e');
    }
  }
}
