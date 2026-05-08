import 'package:dio/dio.dart';
import '../../services/auth_service.dart';

/// Attaches Bearer token to every outgoing Dio request.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._authService);

  final AuthService _authService;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _authService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expired — clear storage
      await _authService.clearAll();
    }
    handler.next(err);
  }
}