import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mauthn_app/const.dart';

class APIError {
  late String message;
  APIError(this.message);
}

typedef APIResponse = Response;

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ))
      ..interceptors.add(
        LogInterceptor(
          requestHeader: true,
        ),
      );
  }

  Future<APIResponse> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } catch (e, s) {
      log('Error in GET request: $e',
          stackTrace: s, error: e, name: "ApiService GET: ");
      rethrow;
    }
  }

  Future<APIResponse> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } catch (e, s) {
      log('Error in POST request: $e',
          error: e, stackTrace: s, name: "ApiService POST: ");

      rethrow;
    }
  }
}
