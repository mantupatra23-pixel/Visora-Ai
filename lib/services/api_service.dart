import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio = Dio();

  ApiService({required this.baseUrl}) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 20);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<Map<String, dynamic>> createVideo(Map<String, dynamic> body) async {
    final res = await _dio.post('/create-video', data: body);
    return Map<String, dynamic>.from(res.data);
  }

  Future<Map<String, dynamic>> startRender(String jobId) async {
    final res = await _dio.get('/render/start/$jobId');
    return Map<String, dynamic>.from(res.data);
  }

  Future<Map<String, dynamic>> getJobStatus(String jobId) async {
    final res = await _dio.get('/job/$jobId');
    return Map<String, dynamic>.from(res.data);
  }

  Future<Response<List<int>>> downloadVideo(String jobId) async {
    // returns bytes; frontend can open url directly too
    final res = await _dio.get<List<int>>('/download/$jobId',
        options: Options(responseType: ResponseType.bytes));
    return res;
  }

  Future<Map<String, dynamic>> health() async {
    final res = await _dio.get('/health');
    return Map<String, dynamic>.from(res.data);
  }
}
