import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiService({required this.baseUrl, Map<String, String>? headers})
      : defaultHeaders = headers ?? {'Content-Type': 'application/json'};

  // Create video job (POST /create-video)
  Future<Map<String, dynamic>> createVideo(Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/create-video');
    final res = await http.post(url, headers: defaultHeaders, body: json.encode(body));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('createVideo failed: ${res.statusCode} ${res.body}');
  }

  // Start render (GET /render/start/{job_id})
  Future<Map<String, dynamic>> startRender(String jobId) async {
    final url = Uri.parse('$baseUrl/render/start/$jobId');
    final res = await http.get(url, headers: defaultHeaders);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('startRender failed: ${res.statusCode} ${res.body}');
  }

  // Get job status (GET /job/{job_id})
  Future<Map<String, dynamic>> getJob(String jobId) async {
    final url = Uri.parse('$baseUrl/job/$jobId');
    final res = await http.get(url, headers: defaultHeaders);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('getJob failed: ${res.statusCode} ${res.body}');
  }

  // Download link (optional helper)
  String videoUrl(String jobId) {
    // Use the documented URL pattern
    return '$baseUrl/videos/$jobId.mp4';
  }
}
