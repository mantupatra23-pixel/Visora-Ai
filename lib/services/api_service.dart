import 'package:dio/dio.dart';
import 'dart:async';

class ApiService {
  final String baseUrl;
  final Dio _dio;
  ApiService({required this.baseUrl}) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Create job to generate video
  Future<Map<String, dynamic>> createGeneration({
    required String script,
    String quality = 'sd', // sd|hd|uhd
    String template = 'default',
    String voice = 'default',
  }) async {
    final resp = await _dio.post('/api/generate', data: {
      'script': script,
      'quality': quality,
      'template': template,
      'voice': voice,
    });
    return resp.data;
  }

  // Poll status by job id
  Future<Map<String, dynamic>> getJobStatus(String jobId) async {
    final resp = await _dio.get('/api/status/$jobId');
    return resp.data;
  }

  // List user videos
  Future<List<dynamic>> fetchVideos() async {
    final resp = await _dio.get('/api/videos');
    return resp.data as List<dynamic>;
  }

  // Download/stream URL for video id
  Future<Map<String, dynamic>> getVideo(String id) async {
    final resp = await _dio.get('/api/video/$id');
    return resp.data;
  }

  // Optional: cancel job
  Future<void> cancelJob(String jobId) async {
    await _dio.post('/api/cancel', data: {'id': jobId});
  }
}
