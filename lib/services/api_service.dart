import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio;

  ApiService({required this.baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 15), receiveTimeout: const Duration(seconds: 15)));

  /// create job with script, characters, scenes
  /// returns job id string
  Future<String> createJob(String script, {List<dynamic>? characters, List<dynamic>? scenes}) async {
    final body = {
      'script': script,
      'characters': characters ?? [],
      'scenes': scenes ?? [],
    };
    final res = await _dio.post('/create-video', data: body);
    // expect { job_id: '...' } or { id: '...' }
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

  /// get job status object
  Future<Map<String, dynamic>> getJob(String jobId) async {
    final res = await _dio.get('/job/$jobId');
    if (res.data is Map<String, dynamic>) return Map<String, dynamic>.from(res.data);
    throw Exception('Invalid job response');
  }

  /// download url helper (if backend provides)
  String videoUrl(String jobId) {
    return '$baseUrl/videos/$jobId.mp4';
  }

  /// health check
  Future<bool> health() async {
    try {
      final res = await _dio.get('/health');
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
