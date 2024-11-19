import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:mauthn_app/const.dart';

class APIError {
  late String message;
  APIError(this.message);
}

typedef APIResponse = Response;

class ApiService {
  late Dio _dio;

  ApiService() {
    final jar = CookieJar();
    _dio = Dio(BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ))
      ..interceptors.addAll([
        LogInterceptor(
          requestHeader: true,
        ),
        CookieManager(jar),
      ]);
  }

  Future<APIResponse> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } catch (e, s) {
      log('Error in POST request: $e',
          error: e, stackTrace: s, name: "ApiService GET: ");

      rethrow;
    }
  }

  Future<APIResponse> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e, s) {
      log(e.response?.data);
      log('Error in POST request: $e',
          error: e, stackTrace: s, name: "ApiService POST: ");

      rethrow;
    }
  }
}
