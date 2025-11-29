// lib/services/api_service.dart
import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio;

  ApiService({required this.baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: Duration(milliseconds: 15000),
          receiveTimeout: Duration(milliseconds: 15000),
          responseType: ResponseType.json,
        ));

  /// POST /create-video  (body: { script, characters, scenes, preset? })
  /// returns job id string (job_id)
  Future<String> createJob(String script,
      {List<dynamic>? characters, List<dynamic>? scenes, Map<String, dynamic>? preset}) async {
    final body = {
      'script': script,
      'characters': characters ?? [],
      'scenes': scenes ?? [],
    };
    if (preset != null) body['preset'] = preset;

    final res = await _dio.post('/create-video', data: body);
    // backend should return { job_id: 'xxx' } or { job_id: 'xxx' }
    final data = res.data;
    if (data == null) throw Exception('No response data from create-job');
    final jobId = data['job_id'] ?? data['id'] ?? data['jobId'] ?? data['job_id'.toString()];
    if (jobId == null) throw Exception('createJob response missing job id');
    return jobId.toString();
  }

  /// GET /render/start/{job_id}
  Future<void> startRender(String jobId) async {
    await _dio.get('/render/start/$jobId');
  }

  /// GET /job/{job_id} -> returns JSON map with status/progress/video_url etc.
  Future<Map<String, dynamic>> getJob(String jobId) async {
    final res = await _dio.get('/job/$jobId');
    final data = res.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw Exception('Invalid getJob response');
  }

  /// optional helper to return a download url (if backend exposes static link pattern)
  String videoUrlFor(String jobId) {
    // If backend serves via /videos/{jobId}.mp4
    return '$baseUrl/videos/$jobId.mp4';
  }

  /// health
  Future<bool> health() async {
    try {
      final res = await _dio.get('/health');
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
