// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}

class ApiService {
  final String baseUrl;
  final Dio _dio;

  ApiService({required this.baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
            responseType: ResponseType.json,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        ) {
    // Optional: interceptor for logging (dev)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        requestHeader: false,
        responseHeader: false,
      ),
    );
  }

  // Generic GET
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? extraHeaders,
  }) async {
    try {
      final opts = Options(headers: extraHeaders);
      final Response response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: opts,
      );
      return _parseResponse(response);
    } on DioException catch (e) {
      throw ApiException(_handleDioError(e));
    } catch (e) {
      throw ApiException('Unknown error: $e');
    }
  }

  // Generic POST (JSON)
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? extraHeaders,
  }) async {
    try {
      final opts = Options(headers: extraHeaders);
      final Response response = await _dio.post(
        endpoint,
        data: jsonEncode(body),
        options: opts,
      );
      return _parseResponse(response);
    } on DioException catch (e) {
      throw ApiException(_handleDioError(e));
    } catch (e) {
      throw ApiException('Unknown error: $e');
    }
  }

  // Multipart POST (for files) - example usage
  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required Map<String, dynamic> fields,
    Map<String, List<File>>? files, // key -> list of files
    Map<String, String>? extraHeaders,
  }) async {
    try {
      final form = FormData();

      // Add fields
      fields.forEach((k, v) {
        form.fields.add(MapEntry(k, v.toString()));
      });

      // Add files (if any)
      if (files != null) {
        for (final entry in files.entries) {
          final key = entry.key;
          for (final f in entry.value) {
            final filename = f.path.split(Platform.pathSeparator).last;
            form.files.add(
              MapEntry(
                key,
                MultipartFile.fromFileSync(f.path, filename: filename),
              ),
            );
          }
        }
      }

      final opts = Options(headers: {
        'Content-Type': 'multipart/form-data',
        ...?extraHeaders,
      });

      final Response response = await _dio.post(
        endpoint,
        data: form,
        options: opts,
      );

      return _parseResponse(response);
    } on DioException catch (e) {
      throw ApiException(_handleDioError(e));
    } catch (e) {
      throw ApiException('Unknown error: $e');
    }
  }

  // Parse response and ensure Map<String,dynamic>
  Map<String, dynamic> _parseResponse(Response response) {
    final status = response.statusCode ?? 0;
    if (status >= 200 && status < 300) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      } else if (data is String && data.isNotEmpty) {
        // try decode
        try {
          final decoded = jsonDecode(data);
          return decoded is Map<String, dynamic>
              ? decoded
              : {'data': decoded};
        } catch (_) {
          return {'data': data};
        }
      } else {
        return {'data': data};
      }
    } else {
      throw ApiException(
          'HTTP ${response.statusCode}: ${response.statusMessage ?? 'Error'}');
    }
  }

  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Request timeout. Check your internet connection.';
    } else if (e.type == DioExceptionType.badResponse) {
      final r = e.response;
      final msg =
          'Server ${r?.statusCode ?? ''} ${r?.statusMessage ?? ''}';
      // try to include server error body
      if (r?.data != null) {
        return '$msg - ${r!.data}';
      }
      return msg;
    } else if (e.type == DioExceptionType.cancel) {
      return 'Request was cancelled';
    } else if (e.type == DioExceptionType.unknown) {
      return 'Network error: ${e.message}';
    }
    return e.message ?? 'Request error';
  }

  // Optional: expose low-level dio if needed
  Dio get dio => _dio;
}
