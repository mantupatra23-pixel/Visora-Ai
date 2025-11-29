// lib/state/app_state.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

/// Simple RenderJob model
class RenderJob {
  final String id;
  final String status;
  final double progress;
  final String? videoUrl;

  RenderJob({
    required this.id,
    required this.status,
    this.progress = 0.0,
    this.videoUrl,
  });

  factory RenderJob.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['job_id'] ?? '').toString();
    final status = (json['status'] ?? 'created').toString();
    double progress = 0.0;
    if (json['progress'] is num) {
      progress = (json['progress'] as num).toDouble();
    } else if (json['progress'] is String) {
      progress = double.tryParse(json['progress']) ?? 0.0;
    }
    final videoUrl = json['video_url']?.toString() ?? json['videoUrl']?.toString();
    return RenderJob(id: id, status: status, progress: progress, videoUrl: videoUrl);
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

  // --- characters & scenes (store as dynamic lists so UI can adapt)
  List<dynamic> _characters = [];
  List<dynamic> get characters => _characters;
  void setCharacters(List<dynamic> list) {
    _characters = list;
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

  List<dynamic> _scenes = [];
  List<dynamic> get scenes => _scenes;
  void setScenes(List<dynamic> list) {
    _scenes = list;
    notifyListeners();
  }

  void addScene(dynamic s) {
    _scenes.add(s);
    notifyListeners();
  }

  void reorderScenes(int oldIdx, int newIdx) {
    if (oldIdx < 0 || oldIdx >= _scenes.length) return;
    if (newIdx < 0) newIdx = 0;
    if (newIdx >= _scenes.length) newIdx = _scenes.length - 1;
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

  // --- create job (calls POST /create-video)
  Future<String> startCreateJob() async {
    try {
      _setError(null);
      final body = {
        "script": _script,
        "characters": _characters,
        "scenes": _scenes,
      };

      // backend expects POST /create-video (adjust path if your backend different)
      final res = await api.post('/create-video', body);
      // res can be Map or direct id string; handle common shapes
      String jobId = '';
      if (res is Map) {
        jobId = (res['job_id'] ?? res['id'] ?? '').toString();
      } else {
        jobId = res?.toString() ?? '';
      }

      // fallback: if empty, try reading 'id' inside nested
      if (jobId.isEmpty && res is Map && res.containsKey('data')) {
        final d = res['data'];
        if (d is Map && d.containsKey('job_id')) jobId = d['job_id'].toString();
      }

      // create a minimal RenderJob locally
      _currentJob = RenderJob(id: jobId, status: 'created', progress: 0.0);
      _jobData = {"id": jobId, "status": "created"};
      notifyListeners();
      return jobId;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  // --- call backend to start render (GET /render/start/{job_id})
  Future<void> startRenderJob(String jobId) async {
    try {
      _setError(null);
      await api.get('/render/start/$jobId');
      // start polling automatically
      startPolling(jobId);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // --- poll once and update
  Future<void> pollRenderStatus(String jobId) async {
    try {
      final data = await api.get('/job/$jobId');
      // ensure Map<String,dynamic>
      Map<String, dynamic> mapData;
      if (data is Map<String, dynamic>) {
        mapData = Map<String, dynamic>.from(data);
      } else {
        mapData = {"result": data};
      }
      _jobData = mapData;
      _currentJob = RenderJob.fromJson(mapData);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    }
    notifyListeners();
  }

  // --- start polling repeatedly every intervalMs (default 2000ms)
  void startPolling(String jobId, {int intervalMs = 2000}) {
    // clear existing
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

  // --- stop polling
  void stopPolling() {
    _isPolling = false;
    _pollTimer?.cancel();
    _pollTimer = null;
    notifyListeners();
  }

  // --- clear job
  void clearJob() {
    stopPolling();
    _currentJob = null;
    _jobData = null;
    _lastError = null;
    notifyListeners();
  }

  // --- helper to get video url
  String? get videoUrl => _currentJob == null ? null : _currentJob!.videoUrl;

  // --- convenience small helpers used by UI
  double get progress => _currentJob?.progress ?? 0.0;
  String get status => _currentJob?.status ?? 'created';

  // --- additional small wrappers (some UIs expect these names)
  Future<void> pollStatusOnce(String jobId) => pollRenderStatus(jobId);
  Future<void> startCreateAndRender() async {
    final id = await startCreateJob();
    await startRenderJob(id);
  }

  // --- try to fetch video url directly from backend endpoints if available
  Future<String?> fetchVideoUrlFromApi(String jobId) async {
    try {
      final res = await api.get('/videos/$jobId.mp4'); // unlikely to return data; fallback below
      if (res is String) return res;
      if (res is Map && res['video_url'] != null) return res['video_url'].toString();
      return null;
    } catch (_) {
      return null;
    }
  }
}
