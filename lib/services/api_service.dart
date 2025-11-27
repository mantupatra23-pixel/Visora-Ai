import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio = Dio();

  ApiService({required this.baseUrl});

  Future<dynamic> get(String endpoint) async {
    final res = await _dio.get("$baseUrl$endpoint");
    return res.data; // Always return decoded JSON
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final res = await _dio.post("$baseUrl$endpoint", data: body);
    return res.data; // Always return decoded JSON
  }
}
