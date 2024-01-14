import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gsy_app/common/net/code.dart';
import 'package:gsy_app/common/net/result_data.dart';

class ResponseInterceptors extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    RequestOptions options = response.requestOptions;
    var value;
    try {
      var header = response.headers[Headers.contentTypeHeader];
      if (header != null && header.toString().contains('text')) {
        value = ResultData(response.data, true, Code.SUCCESS);
      } else if (response.statusCode! >= 200 && response.statusCode! < 300) {
        value = ResultData(response.data, true, Code.SUCCESS, headers: response.headers);
      }
    } catch (e) {
      debugPrint('-->response[${options.path}]: $e');
      value = ResultData(response.data, false, response.statusCode, headers: response.headers);
    }
    response.data = value;
    return handler.next(response);
  }
}
