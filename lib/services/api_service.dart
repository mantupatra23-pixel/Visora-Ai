// lib/services/api_service.dart
import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  late final Dio _dio;

  ApiService({required this.baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 2), // 120 seconds
        sendTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        // you can add headers here if needed:
        // headers: {'Content-Type': 'application/json'},
      ),
    );

    // Optional: global interceptors for logging (comment out in prod)
    // _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  /// Create job on backend. Returns job id string.
  Future<String> createJob(String script,
      {List<dynamic>? characters, List<dynamic>? scenes}) async {
    final body = {
      'script': script,
      'characters': characters ?? [],
      'scenes': scenes ?? [],
    };

    try {
      final res = await _dio.post('/create-video', data: body);
      final data = res.data;

      if (data is Map<String, dynamic>) {
        // backend may return { "job_id": "..." } or { "id": "..." }
        final jobId = (data['job_id'] ?? data['id'] ?? '').toString();
        if (jobId.isNotEmpty) return jobId;
      }

      throw Exception('Invalid createJob response');
    } on DioException catch (e) {
      // helpful error message for debugging
      throw Exception('createJob failed: ${e.message} ${e.response?.statusCode ?? ''}');
    } catch (e) {
      rethrow;
    }
  }

  /// Ask backend to start rendering for a job
  Future<void> startRender(String jobId) async {
    try {
      await _dio.get('/render/start/$jobId');
    } on DioException catch (e) {
      throw Exception('startRender failed: ${e.message}');
    }
  }

  /// Get job status object (as Map)
  Future<Map<String, dynamic>> getJob(String jobId) async {
    try {
      final res = await _dio.get('/job/$jobId');
      final data = res.data;
      if (data is Map<String, dynamic>) return data;
      throw Exception('Invalid job response');
    } on DioException catch (e) {
      throw Exception('getJob failed: ${e.message}');
    }
  }

  /// Convenience: return video URL if backend serves videos at /videos/<id>.mp4
  String videoUrl(String jobId) {
    // ensure baseUrl doesn't double slash
    final trimmed = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    return '$trimmed/videos/$jobId.mp4';
  }

  /// Health check
  Future<bool> health() async {
    try {
      final res = await _dio.get('/health');
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Optional helper to change timeouts at runtime if needed
  void setTimeouts({Duration? connect, Duration? receive, Duration? send}) {
    final opts = _dio.options;
    if (connect != null) opts.connectTimeout = connect;
    if (receive != null) opts.receiveTimeout = receive;
    if (send != null) opts.sendTimeout = send;
  }
}
