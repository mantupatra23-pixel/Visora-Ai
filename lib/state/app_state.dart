import 'dart:async';

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/render_job.dart';

class AppState extends ChangeNotifier {
  final ApiService api;
  AppState({required this.api});

  // script
  String _script = '';
  String get script => _script;
  void setScript(String s) {
    _script = s;
    notifyListeners();
  }

  // characters & scenes (store as dynamic to keep simple)
  final List<dynamic> _characters = [];
  List<dynamic> get characters => _characters;
  void setCharacters(List<dynamic> list) {
    _characters.clear();
    _characters.addAll(list);
    notifyListeners();
  }

  void addCharacter(dynamic c) {
    _characters.add(c);
    notifyListeners();
  }

  void removeCharacterAt(int i) {
    if (i >= 0 && i < _characters.length) {
      _characters.removeAt(i);
      notifyListeners();
    }
  }

  final List<dynamic> _scenes = [];
  List<dynamic> get scenes => _scenes;
  void setScenes(List<dynamic> list) {
    _scenes.clear();
    _scenes.addAll(list);
    notifyListeners();
  }

  void addScene(dynamic s) {
    _scenes.add(s);
    notifyListeners();
  }

  void reorderScenes(int oldIdx, int newIdx) {
    if (newIdx > oldIdx) newIdx--;
    final it = _scenes.removeAt(oldIdx);
    _scenes.insert(newIdx, it);
    notifyListeners();
  }

  // current job object and raw jobData
  RenderJob? _currentJob;
  RenderJob? get currentJob => _currentJob;

  Map<String, dynamic>? _jobData;
  Map<String, dynamic>? get jobData => _jobData;

  String? _lastError;
  String? get lastError => _lastError;

  void _setError(String? e) {
    _lastError = e;
    notifyListeners();
  }

  // polling
  Timer? _pollTimer;
  bool _isPolling = false;
  bool get isPolling => _isPolling;

  void _setJobDataFromMap(Map<String, dynamic> data) {
    _jobData = Map<String, dynamic>.from(data);
    _currentJob = RenderJob.fromJson(_jobData!);
    notifyListeners();
  }

  // create job returns job id
  Future<String> startCreateJob() async {
    try {
      final jobId = await api.createJob(_script, characters: _characters, scenes: _scenes);
      _currentJob = RenderJob(id: jobId, status: 'created', progress: 0.0, videoUrl: null);
      _jobData = {'id': jobId, 'status': 'created', 'progress': 0};
      _setError(null);
      notifyListeners();
      return jobId;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  // start render on backend
  Future<void> startRenderJob(String jobId) async {
    try {
      await api.startRender(jobId);
      // start polling automatically
      startPolling(jobId);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // poll once and update
  Future<void> pollRenderStatus(String jobId) async {
    try {
      final data = await api.getJob(jobId);
      _setJobDataFromMap(data);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // repeated polling
  void startPolling(String jobId, {int intervalMs = 2000}) {
    stopPolling();
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

  void stopPolling() {
    _isPolling = false;
    _pollTimer?.cancel();
    _pollTimer = null;
    notifyListeners();
  }

  void clearJob() {
    stopPolling();
    _currentJob = null;
    _jobData = null;
    _lastError = null;
    notifyListeners();
  }

  // helper for video url
  String? get videoUrl => _currentJob?.videoUrl ?? (_jobData != null ? ( _jobData!['video_url'] ?? _jobData!['videoUrl'] ?? null )?.toString() : null);

  String? get jobId => _currentJob?.id ?? (_jobData != null ? (_jobData!['id'] ?? _jobData!['job_id'])?.toString() : null);
}
