// lib/state/app_state.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
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
    final id = (json['id'] ?? json['job_id'] ?? json['jobId'] ?? '')?.toString();
    final status = (json['status'] ?? 'created').toString();
    final progressRaw = json['progress'];
    double progress = 0.0;
    if (progressRaw is num) progress = progressRaw.toDouble();
    if (progressRaw is String) {
      final parsed = double.tryParse(progressRaw) ?? 0.0;
      progress = parsed;
    }
    final videoUrl = (json['video_url'] ?? json['videoUrl'] ?? json['url'])?.toString();
    return RenderJob(id: id ?? '', status: status, progress: progress, videoUrl: videoUrl);
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

  // --- characters & scenes (dynamic lists so UI can store maps/models)
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
    if (newIdx > oldIdx) newIdx--;
    if (oldIdx < 0 || oldIdx >= _scenes.length || newIdx < 0 || newIdx > _scenes.length) return;
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

  // helper getter for UI (this fixes st.jobId errors)
  String? get jobId => _currentJob?.id;

  // --- polling
  Timer? _pollTimer;
  bool _isPolling = false;
  bool get isPolling => _isPolling;

  void _setError(String? e) {
    _lastError = e;
    notifyListeners();
  }

  // --- create job (returns jobId)
  Future<String> startCreateJob() async {
    try {
      _setError(null);
      final jobId = await api.createJob(
        _script,
        characters: _characters,
        scenes: _scenes,
      );
      _currentJob = RenderJob(id: jobId, status: 'created', progress: 0.0);
      _jobData = {'id': jobId, 'status': 'created'};
      notifyListeners();
      return jobId;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  // start render flow (backend)
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
      _jobData = Map<String, dynamic>.from(data);
      _currentJob = RenderJob.fromJson(_jobData!);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    }
  }

  // start repeated polling
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

  // helper to get video url (if backend provides direct static URL)
  String? get videoUrl => _currentJob?.videoUrl ?? (_jobData != null ? (_jobData!['video_url'] ?? _jobData!['videoUrl'])?.toString() : null);

  // helper: fetch latest job and update videoUrl field if present
  Future<void> refreshJob() async {
    if (_currentJob == null) return;
    await pollRenderStatus(_currentJob!.id);
  }
}
