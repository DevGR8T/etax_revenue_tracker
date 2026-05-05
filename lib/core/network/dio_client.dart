import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import '../services/auth_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Single Dio instance for DummyJSON only.
/// Supabase SDK handles all auth HTTP.
/// Dio responsible for product and user data.
@module
abstract class DioModule {
  /// Dio instance for DummyJSON products and users API.
  @Named('dummyjson')
  @lazySingleton
  Dio dummyJsonDio(AuthService authService) {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['DUMMY_JSON_BASE_URL'] ?? 'https://dummyjson.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(authService),
      LoggingInterceptor(),
    ]);

    return dio;
  }
}