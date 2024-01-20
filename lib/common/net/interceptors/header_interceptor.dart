import 'package:dio/dio.dart';

class HeaderInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.connectTimeout = const Duration(seconds: 30);
    options.receiveTimeout = const Duration(seconds: 30);
    // return super.onRequest(options, handler);
    return handler.next(options);
  }
}
