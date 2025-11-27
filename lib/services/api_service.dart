// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final Duration timeout;

  ApiService({required this.baseUrl, this.timeout = const Duration(seconds: 30)});

  Uri _uri(String path) {
    if (path.startsWith('http')) return Uri.parse(path);
    return Uri.parse(baseUrl + path);
  }

  Future<http.Response> get(String path, {Map<String, String>? headers}) {
    final uri = _uri(path);
    return http.get(uri, headers: headers).timeout(timeout);
  }

  Future<http.Response> post(String path, {Map<String, String>? headers, Object? body}) {
    final uri = _uri(path);
    final h = <String, String>{'Content-Type': 'application/json'};
    if (headers != null) h.addAll(headers);
    return http.post(uri, headers: h, body: body == null ? null : jsonEncode(body)).timeout(timeout);
  }

  Future<http.Response> put(String path, {Map<String, String>? headers, Object? body}) {
    final uri = _uri(path);
    final h = <String, String>{'Content-Type': 'application/json'};
    if (headers != null) h.addAll(headers);
    return http.put(uri, headers: h, body: body == null ? null : jsonEncode(body)).timeout(timeout);
  }

  // Add other helpers as needed (delete, patch, file upload etc.)
}
