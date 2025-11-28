import 'package:dio/dio.dart';

class ApiService {
  final String baseUrl;
  final Dio _dio = Dio();

  ApiService({required this.baseUrl}) {
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  // ---------------------------
  // GENERIC GET
  // ---------------------------
  Future<dynamic> get(String endpoint) async {
    final res = await _dio.get("$baseUrl$endpoint");
    return res.data;
  }

  // ---------------------------
  // GENERIC POST
  // ---------------------------
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final res = await _dio.post("$baseUrl$endpoint", data: body);
    return res.data;
  }

  // ---------------------------
  // CREATE VIDEO JOB
  // POST /create-video
  // ---------------------------
  Future<String> createJob(String script) async {
    final data = {"script": script};
    final res = await post("/create-video", data);
    return res["job_id"];
  }

  // ---------------------------
  // START RENDER
  // GET /render/start/{job_id}
  // ---------------------------
  Future<dynamic> startRender(String jobId) async {
    final res = await get("/render/start/$jobId");
    return res;
  }

  // ---------------------------
  // JOB STATUS
  // GET /job/{job_id}
  // ---------------------------
  Future<dynamic> pollStatus(String jobId) async {
    final res = await get("/job/$jobId");
    return res;
  }

  // ---------------------------
  // DOWNLOAD VIDEO
  // GET /download/{job_id}
  // ---------------------------
  Future<String> getVideoUrl(String jobId) async {
    return "$baseUrl/videos/$jobId.mp4";
  }
}
