// lib/state/app_state.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

// Simple RenderJob model (adjust fields if backend different)
class RenderJob {
  String id;
  String status;
  double progress;
  String? videoUrl;

  RenderJob({
    required this.id,
    required this.status,
    this.progress = 0.0,
    this.videoUrl,
  });

  factory RenderJob.fromJson(Map<String, dynamic> json) {
    return RenderJob(
      id: (json['id'] ?? json['job_id'] ?? '').toString(),
      status: (json['status'] ?? 'created').toString(),
      progress: (json['progress'] is num) ? (json['progress'] as num).toDouble() : 0.0,
      videoUrl: json['video_url']?.toString(),
    );
  }
}

class AppState extends ChangeNotifier {
  final ApiService api;
  AppState({required this.api});

  // --- script
  String _script = '';
  String get script => _script;
  void setScript(String s) {
    _script = s;
    notifyListeners();
  }

  // --- characters & scenes (dynamic lists so compile passes)
  List<dynamic> _characters = [];
  List<dynamic> get characters => _characters;
  void setCharacters(List<dynamic> list) { _characters = list; notifyListeners(); }
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

  // --- current job + raw jobData + error
  RenderJob? _currentJob;
  RenderJob? get currentJob => _currentJob;

  Map<String, dynamic>? _jobData;
  Map<String, dynamic>? get jobData => _jobData;

  String? _lastError;
  String? get lastError => _lastError;

  // --- polling
  Timer? _pollTimer;
  bool _isPolling = false;

  bool get isPolling => _isPolling;

  void _setError(String? e) {
    _lastError = e;
    notifyListeners();
  }

  // create job
  Future<String> startCreateJob() async {
    try {
      final jobId = await api.createJob(_script, extras: {
        "characters": _characters,
        "scenes": _scenes,
      });
      _currentJob = RenderJob(id: jobId, status: "created", progress: 0.0);
      _jobData = {"id": jobId, "status": "created"};
      notifyListeners();
      return jobId;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  // call backend to start render
  Future<void> startRenderJob(String jobId) async {
    try {
      await api.startRender(jobId);
      // start polling automatically
      startPolling(jobId);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // poll once and update
  Future<void> pollRenderStatus(String jobId) async {
    try {
      final data = await api.getJob(jobId);
      // ensure Map<String,dynamic>
      _jobData = Map<String, dynamic>.from(data);
      _currentJob = RenderJob.fromJson(_jobData!);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // start polling repeatedly every intervalMs
  void startPolling(String jobId, {int intervalMs = 2000}) {
    stopPolling(); // clear existing if any
    _isPolling = true;
    _pollTimer = Timer.periodic(Duration(milliseconds: intervalMs), (t) async {
      if (!_isPolling) {
        t.cancel();
        return;
      }
      await pollRenderStatus(jobId);
      if (_currentJob != null) {
        final s = _currentJob!.status;
        if (s == 'completed' || s == 'failed') {
          stopPolling();
        }
      }
    });
    notifyListeners();
  }

  // stop polling
  void stopPolling() {
    _isPolling = false;
    _pollTimer?.cancel();
    _pollTimer = null;
    notifyListeners();
  }

  // clear job
  void clearJob() {
    stopPolling();
    _currentJob = null;
    _jobData = null;
    _lastError = null;
    notifyListeners();
  }

  // helper to get video url from api
  String? get videoUrl => _currentJob == null ? null : api.videoUrl(_currentJob!.id);
}
