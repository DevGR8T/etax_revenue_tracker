import 'package:dio/dio.dart';
import '../../config/flavor_config.dart';

/// Logs Dio requests is done only in dev mode only.
/// NEVER logs in production — no tokens, no payment data.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (FlavorConfig.isDev) {
      // ignore: avoid_print
      print('[DIO REQUEST] ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (FlavorConfig.isDev) {
      // ignore: avoid_print
      print('[DIO RESPONSE] ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (FlavorConfig.isDev) {
      // ignore: avoid_print
      print('[DIO ERROR] ${err.response?.statusCode} ${err.message}');
    }
    handler.next(err);
  }
}