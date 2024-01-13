import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gsy_app/common/net/code.dart';
import 'package:gsy_app/common/net/interceptors/error_interceptor.dart';
import 'package:gsy_app/common/net/interceptors/header_interceptor.dart';
import 'package:gsy_app/common/net/interceptors/response_interceptor.dart';
import 'package:gsy_app/common/net/interceptors/token_interceptor.dart';
import 'package:gsy_app/common/net/result_data.dart';

class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  Dio _dio = Dio();

  final TokenInterceptors _tokenInterceptors = TokenInterceptors();

  HttpManager() {
    _dio.interceptors.add(HeaderInterceptors());
    _dio.interceptors.add(_tokenInterceptors);
    _dio.interceptors.add(LogInterceptor());
    _dio.interceptors.add(ErrorInterceptors());
    _dio.interceptors.add(ResponseInterceptors());
  }

  Future<ResultData?> netFetch(url, params, Map<String, dynamic>? header, Options? options, {noTip = false}) async {
    Map<String, dynamic> headers = HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    if (options != null) {
      options.headers = headers;
    } else {
      options = Options(method: 'get');
      options.headers = headers;
    }

    resultError(DioException e) {
      debugPrint('-->resultError: $e');
      Response? errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = Response(
          requestOptions: RequestOptions(path: url),
          statusCode: 666,
        );
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorResponse?.statusCode == Code.NETWORK_TIMEOUT;
      }
      return ResultData(
          Code.errorHandleFunction(errorResponse?.statusCode, e.message, noTip), false, errorResponse?.statusCode);
    }

    Response response;
    try {
      debugPrint('-->begin[1] request: $url');
      response = await _dio.request(url, data: params, options: options);
      debugPrint('-->begin[1.2]');
    } on DioException catch (e) {
      debugPrint('-->begin[2]: $e');
      return resultError(e);
    }
    debugPrint('-->begin[3]');
    if (response.data is DioException) {
      return resultError(response.data);
    }
    return response.data;
  }

  clearAuthorization() {
    _tokenInterceptors.clearAuthorization();
  }

  getAuthorization() async {
    return _tokenInterceptors.getAuthorization();
  }
}

final HttpManager httpManager = HttpManager();
