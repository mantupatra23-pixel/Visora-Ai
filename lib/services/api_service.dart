// lib/services/api_service.dart
import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio = Dio();

  ApiService({required this.baseUrl}) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 50),
      responseType: ResponseType.json,
      headers: {
        'Accept': 'application/json',
        // अगर x-api-key चाहिए तो यहाँ add कर सकते हो dinamically
      },
    );
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final res = await _dio.get(endpoint);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final res = await _dio.post(endpoint, data: data);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  // Optional helper for posting form-data / multipart if needed later
  Future<dynamic> postForm(String endpoint, FormData formData) async {
    try {
      final res = await _dio.post(endpoint, data: formData);
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
