import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio;

  ApiService({required this.baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(minutes: 2), // backend may be slow
          sendTimeout: const Duration(seconds: 30),
          responseType: ResponseType.json,
        )) {
    // Optional: add simple interceptor for logs (disabled in production)
    _dio.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
      // pass through
      handler.next(e);
    }));
  }

  /// create job with script, characters, scenes
  /// returns job id string
  Future<String> createJob(String script, {List<dynamic>? characters, List<dynamic>? scenes}) async {
    final body = {
      'script': script,
      'characters': characters ?? [],
      'scenes': scenes ?? [],
    };

    final res = await _dio.post('/create-video', data: body);
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return (data['job_id'] ?? data['id'] ?? '').toString();
    }
    throw Exception('Invalid createJob response');
  }

  /// start rendering on backend
  Future<void> startRender(String jobId) async {
    await _dio.get('/render/start/$jobId');
  }

  /// get job status object (Map<String,dynamic>)
  Future<Map<String, dynamic>> getJob(String jobId) async {
    final res = await _dio.get('/job/$jobId');
    final data = res.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    throw Exception('Invalid job response');
  }

  /// helper to build download URL if backend stores videos in a known path
  String videoUrl(String jobId) {
    // adapt if backend returns direct url; this helper creates a predictable URL
    return '$baseUrl/videos/$jobId.mp4';
  }

  /// health check
  Future<bool> health() async {
    try {
      final res = await _dio.get('/health');
      if (res.statusCode == 200) return true;
    } catch (_) {}
    return false;
  }
}
