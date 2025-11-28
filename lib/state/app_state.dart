import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  final ApiService api;

  AppState({required this.api});

  String? jobId;
  Map<String, dynamic>? jobData;
  String status = 'idle';
  double progress = 0.0;
  Timer? _pollTimer;
  bool isBusy = false;
  String? lastError;

  // Create video job
  Future<void> createVideoJob({
    required String script,
    List<Map<String, dynamic>>? scenes,
    List<Map<String, dynamic>>? characters,
    Map<String, dynamic>? options,
  }) async {
    try {
      isBusy = true;
      lastError = null;
      notifyListeners();

      final body = {
        'script': script,
        'scenes': scenes ?? [],
        'characters': characters ?? [],
        'options': options ?? {},
      };

      final res = await api.createVideo(body);
      // Expect res to contain job_id or id
      jobId = res['job_id']?.toString() ?? res['id']?.toString();
      jobData = res;
      status = jobData?['status']?.toString() ?? 'created';
      progress = _extractProgress(jobData);
      notifyListeners();
    } catch (e) {
      lastError = e.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  // Start render
  Future<void> startRender() async {
    if (jobId == null) throw Exception('No jobId to start render');
    try {
      isBusy = true;
      lastError = null;
      notifyListeners();

      final res = await api.startRender(jobId!);
      // backend may return updated job
      jobData = res;
      status = jobData?['status']?.toString() ?? status;
      progress = _extractProgress(jobData);
      notifyListeners();

      startPolling(); // start polling after request
    } catch (e) {
      lastError = e.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  // Poll job status every interval
  void startPolling({Duration interval = const Duration(seconds: 2)}) {
    stopPolling();
    _pollTimer = Timer.periodic(interval, (_) async {
      await pollStatusOnce();
    });
  }

  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  Future<void> pollStatusOnce() async {
    if (jobId == null) return;
    try {
      final res = await api.getJob(jobId!);
      jobData = res;
      status = jobData?['status']?.toString() ?? status;
      progress = _extractProgress(jobData);
      notifyListeners();

      if (status == 'completed' || status == 'failed') {
        stopPolling();
      }
    } catch (e) {
      // keep polling but save error
      lastError = e.toString();
      notifyListeners();
    }
  }

  // Helper to get video URL
  String? get videoUrl {
    if (jobId == null) return null;
    return api.videoUrl(jobId!);
  }

  // Clear job
  void clearJob() {
    jobId = null;
    jobData = null;
    status = 'idle';
    progress = 0;
    lastError = null;
    stopPolling();
    notifyListeners();
  }

  double _extractProgress(Map<String, dynamic>? data) {
    if (data == null) return 0.0;
    try {
      final p = data['progress'];
      if (p == null) return 0.0;
      if (p is num) return p.toDouble().clamp(0.0, 100.0) / 100.0;
      final pnum = double.tryParse(p.toString());
      return (pnum ?? 0.0).clamp(0.0, 100.0) / 100.0;
    } catch (_) {
      return 0.0;
    }
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
