import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio = Dio();

  ApiService({required this.baseUrl}) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = 15000;
    _dio.options.receiveTimeout = 15000;
  }

  // create video job (POST /create-video)
  Future<Map<String, dynamic>> createVideo(Map<String, dynamic> body) async {
    final res = await _dio.post('/create-video', data: body);
    return (res.data as Map).cast<String, dynamic>();
  }

  // start render (GET /render/start/{job_id})
  Future<Map<String, dynamic>> startRender(String jobId) async {
    final res = await _dio.get('/render/start/$jobId');
    return (res.data as Map).cast<String, dynamic>();
  }

  // get job status (GET /job/{job_id})
  Future<Map<String, dynamic>> getJob(String jobId) async {
    final res = await _dio.get('/job/$jobId');
    return (res.data as Map).cast<String, dynamic>();
  }

  // download (optional) - returns bytes
  Future<Response> downloadVideo(String jobId) async {
    return _dio.get('/download/$jobId', options: Options(responseType: ResponseType.bytes));
  }
}
