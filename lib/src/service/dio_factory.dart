import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'default_headers_interceptor.dart';

class DioFactory {
  static Dio? _dio;

  final Map<String, String>? headers;
  final String baseUrl;

  DioFactory({
    required this.baseUrl,
    this.headers,
  });

  // Getter to initialize Dio if needed
  static Dio get dio {
    if (_dio == null) {
      throw Exception(
          'Dio not initialized. Call CustomDioFactory.initialize() first.');
    }
    return _dio!;
  }

  // Initialize Dio with BaseOptions and interceptors
  static void initialize(
    String baseUrl, {
    Map<String, String>? headers,
    int connectTimeout = 30,
    int sendTimeout = 100,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: Duration(seconds: connectTimeout),
        sendTimeout: Duration(seconds: sendTimeout),
      ),
    );

    // Add interceptors to the Dio instance
    if(kDebugMode){
      _dio!.interceptors.addAll([
        LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
          request: false,
          requestBody: true,
        ),
        DefaultHeadersInterceptor(dio: _dio!, headers: headers),
      ]);
    }
  }
}
