import 'package:dio/dio.dart';

class DefaultHeadersInterceptor extends Interceptor {
  final Dio dio;
  final Map<String, String>? headers;

  DefaultHeadersInterceptor({
    required this.dio,
    this.headers,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    Map<String, String> defaultHeader = {
      'Accept': 'application/json',
    };
    if (headers != null) {
      defaultHeader.addAll(headers!);
    }
    options.headers.addAll(defaultHeader);

    return handler.next(options);
  }
}
