import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/**
 * Log 拦截器
 * Created by guoshuyu
 * on 2019/3/23.
 */
class LogsInterceptors extends InterceptorsWrapper {
  static List<Map?> sHttpResponses = [];
  static List<String?> sResponsesHttpUrl = [];

  static List<Map<String, dynamic>?> sHttpRequest = [];
  static List<String?> sRequestHttpUrl = [];

  static List<Map<String, dynamic>?> sHttpError = [];
  static List<String?> sHttpErrorUrl = [];

  @override
  onRequest(RequestOptions options, handler) async {
    var error;
    try {
      addLogic(sRequestHttpUrl, options.path);
      var data;
      if (options.data is Map) {
        data = options.data;
      } else {
        data = Map<String, dynamic>();
      }
      var map = {
        "header:": {...options.headers},
      };
      if (options.method == "POST") {
        map["data"] = data;
      }
      addLogic(sHttpRequest, map);
    } catch (e) {
      error = e;
    }
    // debugPrint("""
    // ╔═══════════ 🎈 onRequest 🎈 ═══════════
    // ║ [${options.method}]${options.path}
    // ║ headers: ${options.headers}
    // ║ params: ${options.data}
    // ║-------------------------------------
    // ║ error: $error
    // ╚═════════════════════════════════════
    // """);
    // return super.onRequest(options, handler);
    return handler.next(options);
  }

  @override
  onResponse(Response response, handler) async {
    var error;
    switch (response.data.runtimeType) {
      case Map || List:
        {
          try {
            var data = Map<String, dynamic>();
            data["data"] = response.data;
            addLogic(sResponsesHttpUrl, response.requestOptions.uri.toString());
            addLogic(sHttpResponses, data);
          } catch (e) {
            error = e;
          }
        }
      case String:
        {
          try {
            var data = Map<String, dynamic>();
            data["data"] = response.data;
            addLogic(sResponsesHttpUrl, response.requestOptions.uri.toString());
            addLogic(sHttpResponses, data);
          } catch (e) {
            error = e;
          }
        }
    }
    var date = DateTime.now();
    debugPrint("""
    ╔═══════════ 🎈 onResponse 🎈 ═══════════
    ║ date: $date
    ║ URL: [${response.requestOptions.method}]${response.realUri}
    ║-------------------------------------
    ║ Headers: ${response.requestOptions.headers}
    ║ Parameters: ${response.requestOptions.data}
    ║---------- 🎈 Response 🎈 ----------
    ║ Response[${response.statusCode}-${response.data.result}]: ${response.data.data.toString().length > 200 ? response.data.data.toString().substring(0, 200) : response.data.data}
    ║ Error: $error
    ║ URL: [${response.requestOptions.method}]${response.realUri}
    ║ date: $date
    ╚═════════════════════════════════════
    """);
    // return super.onResponse(response, handler);
    return handler.next(response);
  }

  @override
  onError(DioException err, handler) async {
    try {
      addLogic(sHttpErrorUrl, err.requestOptions.path);
      var errors = Map<String, dynamic>();
      errors["error"] = err.message;
      addLogic(sHttpError, errors);
    } catch (e) {
      debugPrint('-->onError: $e');
    }
    var date = DateTime.now();
    debugPrint("""
    ╔═══════════ 🎈 onError 🎈 ═══════════
    ║ date: $date
    ║ URL: [${err.requestOptions.method}]${err.response?.realUri}
    ║-------------------------------------
    ║ Headers: ${err.requestOptions.headers}
    ║ Parameters: ${err.requestOptions.data}
    ║---------- 🎈 Response 🎈 ----------
    ║ Response[${err.response?.statusCode}]: ${err.response?.data}
    ║ Error: $err
    ║ URL: [${err.requestOptions.method}]${err.response?.realUri}
    ║ date: $date
    ╚═════════════════════════════════════
    """);
    // return super.onError(err, handler);
    return handler.next(err);
  }

  static addLogic(List list, data) {
    if (list.length > 20) {
      list.removeAt(0);
    }
    list.add(data);
  }
}
