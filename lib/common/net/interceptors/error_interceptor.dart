import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:gsy_app/common/net/code.dart';
import 'package:gsy_app/common/net/result_data.dart';

class ErrorInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return handler.reject(DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          response: Response(
              requestOptions: options,
              data: ResultData(Code.errorHandleFunction(Code.NETWORK_ERROR, '', false), false, Code.NETWORK_ERROR))));
    }
    return super.onRequest(options, handler);
  }
}
