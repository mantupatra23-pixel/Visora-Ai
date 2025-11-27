import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class VisoraApi {
  final String base;
  VisoraApi({required this.base});

  Future<Map<String, dynamic>> createProject({
    required String script,
    required List<Map<String, dynamic>> characters,
    required List<Map<String, dynamic>> scenes,
    Map<String, dynamic>? renderSettings,
  }) async {
    final uri = Uri.parse('$base/create_project');
    final body = jsonEncode({
      'script': script,
      'characters': characters,
      'scenes': scenes,
      'renderSettings': renderSettings ?? {},
    });
    final r = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: body);
    if (r.statusCode >= 200 && r.statusCode < 300) return jsonDecode(r.body);
    throw Exception('createProject failed ${r.statusCode} ${r.body}');
  }

  Future<Map<String, dynamic>> startRender(String projectId) async {
    final uri = Uri.parse('$base/projects/$projectId/start_render');
    final r = await http.post(uri, headers: {'Content-Type': 'application/json'});
    if (r.statusCode >= 200 && r.statusCode < 300) return jsonDecode(r.body);
    throw Exception('startRender failed ${r.statusCode}');
  }

  Future<Map<String, dynamic>> getStatus(String jobId) async {
    final uri = Uri.parse('$base/job/$jobId/status');
    final r = await http.get(uri);
    if (r.statusCode >= 200 && r.statusCode < 300) return jsonDecode(r.body);
    throw Exception('getStatus failed ${r.statusCode}');
  }

  Future<String> uploadAsset(File file) async {
    final uri = Uri.parse('$base/upload');
    final req = http.MultipartRequest('POST', uri);
    req.files.add(await http.MultipartFile.fromPath('file', file.path));
    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body);
      return data['path'] ?? '';
    }
    throw Exception('uploadAsset failed ${res.statusCode}');
  }
}
