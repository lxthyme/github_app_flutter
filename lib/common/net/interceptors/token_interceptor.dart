import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gsy_app/common/config/config.dart';
import 'package:gsy_app/common/local/local_storage.dart';
import 'package:gsy_app/common/net/graph/client.dart';

class TokenInterceptors extends InterceptorsWrapper {
  String? _token;

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_token == null) {
      var authorizationCode = await getAuthorization();
      if (authorizationCode != null) {
        _token = authorizationCode;
        await initClient(_token);
      }
    }
    if (_token == null) {
      options.headers['Authorization'] = _token;
    }
    return super.onRequest(options, handler);
  }

  @override
  onResponse(Response response, handler) async {
    try {
      var responseJson = response.data;
      if (response.statusCode == 201 && responseJson['token'] != null) {
        _token = 'token${responseJson['token']}';
        await LocalStorage.save(Config.TOKEN_KEY, _token);
      }
    } catch (e) {
      debugPrint('-->onResponse Error: $e');
    }
    return super.onResponse(response, handler);
  }

  clearAuthorization() {
    _token = null;
    LocalStorage.remove(Config.TOKEN_KEY);
    releaseClient();
  }

  getAuthorization() async {
    String? token = await LocalStorage.get(Config.TOKEN_KEY);
    if (token == null) {
      String? basic = await LocalStorage.get(Config.USER_BASIC_CODE);
      if (basic == null) {
      } else {
        return 'Basic $basic';
      }
    } else {
      _token = token;
      return token;
    }
  }
}
