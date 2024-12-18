import 'package:dio/dio.dart';

import '../utils/logger.dart';
import 'api_url.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.baseUrl = ApiUrl.baseUrl;
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final errorMessage = err.response?.data["errors"]?[0]["message"]?.toString() ?? err.response?.data["message"] ?? err.message;
    logger.e('Status code: $statusCode, Error message: $errorMessage');
    super.onError(err, handler);
  }
  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) {
  //   logger.e(err.response?.statusCode);
  //   super.onError(err, handler);
  // }
}
