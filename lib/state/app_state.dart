import 'package:flutter/material.dart';
import '../services/api_service.dart';

// Placeholder model for RenderJob - adapt fields to your real model
class RenderJob {
  String id;
  String status;
  double progress;
  String? videoUrl;
  RenderJob({required this.id, required this.status, this.progress = 0, this.videoUrl});

  factory RenderJob.fromJson(Map<String, dynamic> json) {
    return RenderJob(
      id: json['id']?.toString() ?? json['job_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'created',
      progress: (json['progress'] is num) ? (json['progress'] as num).toDouble() : 0.0,
      videoUrl: json['video_url']?.toString(),
    );
  }
}

class AppState extends ChangeNotifier {
  final ApiService api;

  AppState({required this.api});

  // script (getter + setter)
  String _script = '';
  String get script => _script;
  void setScript(String s) {
    _script = s;
    notifyListeners();
  }

  // characters / scenes placeholders (lists) - adapt types
  List<dynamic> _characters = [];
  List<dynamic> get characters => _characters;
  void setCharacters(List<dynamic> list) {
    _characters = list;
    notifyListeners();
  }
  void addCharacter(dynamic c) { _characters.add(c); notifyListeners(); }
  void removeCharacterAt(int i) { _characters.removeAt(i); notifyListeners(); }

  List<dynamic> _scenes = [];
  List<dynamic> get scenes => _scenes;
  void setScenes(List<dynamic> list) { _scenes = list; notifyListeners(); }
  void addScene(dynamic s) { _scenes.add(s); notifyListeners(); }
  void reorderScenes(int oldIdx, int newIdx) {
    if (newIdx > oldIdx) newIdx--;
    final it = _scenes.removeAt(oldIdx);
    _scenes.insert(newIdx, it);
    notifyListeners();
  }

  // current job
  RenderJob? _currentJob;
  RenderJob? get currentJob => _currentJob;

  // start create job -> calls API.createJob
  Future<String> startCreateJob() async {
    final jobId = await api.createJob(_script, extras: {
      // you can send characters/scenes if backend expects them
      "characters": _characters,
      "scenes": _scenes,
    });
    _currentJob = RenderJob(id: jobId, status: "created", progress: 0.0);
    notifyListeners();
    return jobId;
  }

  // start render (call startRender)
  Future<void> startRenderJob(String jobId) async {
    await api.startRender(jobId);
    // poll/update maybe here or via pollRenderStatus
    await pollRenderStatus(jobId);
  }

  // poll status once
  Future<void> pollRenderStatus(String jobId) async {
    final Map<String, dynamic> data = await api.getJob(jobId);
    _currentJob = RenderJob.fromJson(data);
    notifyListeners();
  }

  // helper: poll repeatedly (use carefully)
  Future<void> pollUntilFinished(String jobId, {int intervalMs = 2000}) async {
    while (true) {
      await pollRenderStatus(jobId);
      if (_currentJob == null) break;
      if (_currentJob!.status == 'completed' || _currentJob!.status == 'failed') break;
      await Future.delayed(Duration(milliseconds: intervalMs));
    }
  }

  // video url getter
  String? get videoUrl => _currentJob == null ? null : api.videoUrl(_currentJob!.id);

}
