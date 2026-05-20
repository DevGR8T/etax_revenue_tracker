import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/network/network_info.dart';
import '../models/dashboard_user_model.dart';
import '../models/recent_payment_model.dart';

/// Makes two simultaneous API calls — users/1 and products?limit=5.
/// Uses Future.wait — both calls fire at the same time.
/// Mirrors Postman exactly — same endpoints, same params.
abstract class DashboardRemoteDataSource {
  Future<DashboardUserModel> getUser();
  Future<ProductsListModel> getRecentPayments({int limit = 5});
}

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl(
    @Named('dummyjson') this._dio,
    this._networkInfo,
  );

  final Dio _dio;
  final NetworkInfo _networkInfo;

  @override
  Future<DashboardUserModel> getUser() async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      final response = await _dio.get(Endpoints.user);
      return DashboardUserModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<ProductsListModel> getRecentPayments({int limit = 5}) async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      final response = await _dio.get(
        Endpoints.products,
        queryParameters: {'limit': 5, 'skip': 0},
      );
      return ProductsListModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Never _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      throw const NetworkException();
    }
    throw ServerException(
      message: 'Server error. Please try again later.',
      statusCode: e.response?.statusCode,
    );
  }
}