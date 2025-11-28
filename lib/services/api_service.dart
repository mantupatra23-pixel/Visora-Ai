import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio = Dio();

  ApiService({required this.baseUrl}) {
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  // Generic GET
  Future<dynamic> get(String endpoint) async {
    final res = await _dio.get("$baseUrl$endpoint");
    return res.data;
  }

  // Generic POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final res = await _dio.post("$baseUrl$endpoint", data: body);
    return res.data;
  }

  // create-video -> returns { "job_id": "..." }
  Future<String> createJob(String script, {Map<String, dynamic>? extras}) async {
    final body = <String, dynamic>{"script": script};
    if (extras != null) body.addAll(extras);
    final res = await post("/create-video", body);
    // res might be Map -> job_id
    return res is Map && res.containsKey("job_id") ? res["job_id"].toString() : res.toString();
  }

  // start render (GET /render/start/{job_id})
  Future<dynamic> startRender(String jobId) async {
    final res = await get("/render/start/$jobId");
    return res;
  }

  // get job status (GET /job/{job_id})
  Future<Map<String, dynamic>> getJob(String jobId) async {
    final res = await get("/job/$jobId");
    // ensure Map<String,dynamic>
    return res is Map ? Map<String, dynamic>.from(res) : {"status": res.toString()};
  }

  // video url helper
  String videoUrl(String jobId) {
    return "$baseUrl/videos/$jobId.mp4";
  }

  // health check (optional)
  Future<bool> health() async {
    try {
      final res = await get("/health");
      return res == "ok" || (res is Map && (res["status"] == "ok" || res["alive"] == true));
    } catch (_) {
      return false;
    }
  }
}
