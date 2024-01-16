import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gsy_app/common/config/config.dart';

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
    if (Config.DEBUG!) {
      debugPrint("-->onRequest[1]: ${options.path} ${options.method}");
      options.headers.forEach((k, v) => options.headers[k] = v ?? "");
      debugPrint('-->onRequest[2]: ${options.headers.toString()}');
      if (options.data != null) {
        debugPrint('-->onRequest[3]: ${options.data.toString()}');
      }
    }
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
      debugPrint('-->onRequest error: $e');
    }
    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, handler) async {
    if (Config.DEBUG!) {
      debugPrint('-->onResponse: ${response.toString()}');
    }
    switch (response.data.runtimeType) {
      case Map || List:
        {
          try {
            var data = Map<String, dynamic>();
            data["data"] = response.data;
            addLogic(sResponsesHttpUrl, response.requestOptions.uri.toString());
            addLogic(sHttpResponses, data);
          } catch (e) {
            debugPrint('-->onResponse error[1]: $e');
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
            debugPrint('-->onResponse error[2]: $e');
          }
        }
    }
    return super.onResponse(response, handler);
  }

  @override
  onError(DioException err, handler) async {
    if (Config.DEBUG!) {
      debugPrint('-->onError[1]: ${err.toString()}');
      debugPrint('-->onError[2]: ${err.response?.toString()}');
    }
    try {
      addLogic(sHttpErrorUrl, err.requestOptions.path);
      var errors = Map<String, dynamic>();
      errors["error"] = err.message;
      addLogic(sHttpError, errors);
    } catch (e) {
      debugPrint('-->onError: $e');
    }
    return super.onError(err, handler);
  }

  static addLogic(List list, data) {
    if (list.length > 20) {
      list.removeAt(0);
    }
    list.add(data);
  }
}
