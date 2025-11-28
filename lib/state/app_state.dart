import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/character.dart';
import '../models/scene.dart';
import '../models/render_job.dart';

class AppState extends ChangeNotifier {
  final ApiService api;

  // script
  String script = '';

  // characters & scenes
  final List<CharacterModel> characters = [];
  final List<SceneModel> scenes = [];

  // render job
  RenderJob? currentJob;
  Timer? _pollTimer;

  AppState({required this.api});

  // script
  void setScript(String value) {
    script = value;
    notifyListeners();
  }

  // characters
  void setCharacters(List<CharacterModel> list) {
    characters
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  void addCharacter(CharacterModel c) {
    characters.add(c);
    notifyListeners();
  }

  // scenes
  void setScenes(List<SceneModel> list) {
    scenes
      ..clear()
      ..addAll(list);
    notifyListeners();
  }

  void addScene(SceneModel s) {
    scenes.add(s);
    notifyListeners();
  }

  // job control
  void setJob(RenderJob j) {
    currentJob = j;
    notifyListeners();
  }

  void clearJob() {
    currentJob = null;
    _pollTimer?.cancel();
    notifyListeners();
  }

  // Start render flow: create video job and start render
  Future<void> startRenderJob() async {
    try {
      final body = {
        'script': script,
        'scenes': scenes.map((s) => s.toJson()).toList(),
        'characters': characters.map((c) => c.toJson()).toList(),
      };

      final createResp = await api.createVideo(body);
      final jobId = createResp['job_id']?.toString() ?? createResp['id']?.toString();
      if (jobId == null) throw Exception('No job id from create');

      // set local job
      setJob(RenderJob(id: jobId, status: 'created', progress: 0.0));

      // ask backend to start rendering
      await api.startRender(jobId);

      // start polling
      startPolling();
    } catch (e) {
      if (kDebugMode) {
        print('startRenderJob error: $e');
      }
    }
  }

  void startPolling({int intervalSeconds = 2}) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(Duration(seconds: intervalSeconds), (_) async {
      if (currentJob == null) return;
      try {
        final res = await api.getJobStatus(currentJob!.id);
        final updated = RenderJob.fromJson(res);
        updated.videoUrl = res['video_url'] ?? res['videoUrl'] ?? updated.videoUrl;
        setJob(updated);

        if (updated.status == 'completed' || updated.status == 'failed') {
          _pollTimer?.cancel();
        }
      } catch (e) {
        if (kDebugMode) print('poll error: $e');
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}
