import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart'; // 👈 IMPORTANT
import 'package:construction_control/utils/storage_helper.dart';

class Injector {
  static final Injector _singleton = Injector._internal();
  static final Dio _dio = Dio();

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  Dio getDio() {
    BaseOptions options = BaseOptions(
      receiveTimeout: const Duration(seconds: 40),
      connectTimeout: const Duration(seconds: 40),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    _dio.options = options;
    _dio.options.followRedirects = false;

    /// ✅ FIX: SSL handling
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {

      return client;
    };

    _dio.interceptors.clear();
    _dio.interceptors.add(LoggingInterceptors());

    return _dio;
  }

  /// ✅ Token header
  static Future<Options?> getHeaderToken()async {
    String? token = await StorageHelper.getUserToken();

    if (token != null) {
      return Options(
        headers: {
          'Authorization': 'Bearer $token',
          "Accept": "application/json",
        },
      );
    }
    return null;
  }

}
class LoggingInterceptors extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    if (kDebugMode) {
      debugPrint("--> ${options.method} ${options.path}");
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

    if (kDebugMode) {
      log("Response: ${response.data}");
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {

    if (kDebugMode) {
      debugPrint("Error: ${err.message}");
    }

    return handler.next(err);
  }
}
