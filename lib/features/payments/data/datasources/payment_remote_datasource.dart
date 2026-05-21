import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/network/network_info.dart';
import '../models/create_payment_request_model.dart';
import '../models/payment_list_response_model.dart';
import '../models/payment_model.dart';

/// Mirrors every Postman request exactly.
/// Four endpoints — list, search, single, create.
/// Throws typed exceptions — never raw DioException.
abstract class PaymentRemoteDataSource {
  Future<PaymentListResponseModel> getPayments({
    required int limit,
    required int skip,
  });

  Future<PaymentListResponseModel> searchPayments({
    required String query,
    required int limit,
    required int skip,
  });

  Future<PaymentModel> getPaymentDetail(int id);

  Future<PaymentModel> createPayment(
    CreatePaymentRequestModel requestModel,
  );
}

@LazySingleton(as: PaymentRemoteDataSource)
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  PaymentRemoteDataSourceImpl(
    @Named('dummyjson') this._dio,
    this._networkInfo,
  );

  final Dio _dio;
  final NetworkInfo _networkInfo;

  @override
  Future<PaymentListResponseModel> getPayments({
    required int limit,
    required int skip,
  }) async {
    if (!await _networkInfo.isConnected) throw const NetworkException();

    try {
      final response = await _dio.get(
        Endpoints.products,
        queryParameters: {'limit': limit, 'skip': skip},
      );
      return PaymentListResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<PaymentListResponseModel> searchPayments({
    required String query,
    required int limit,
    required int skip,
  }) async {
    if (!await _networkInfo.isConnected) throw const NetworkException();

    try {
      final response = await _dio.get(
        Endpoints.productsSearch,
        queryParameters: {'q': query, 'limit': limit, 'skip': skip},
      );
      return PaymentListResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<PaymentModel> getPaymentDetail(int id) async {
    if (!await _networkInfo.isConnected) throw const NetworkException();

    try {
      final response = await _dio.get(Endpoints.productById(id));
      return PaymentModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<PaymentModel> createPayment(
    CreatePaymentRequestModel requestModel,
  ) async {
    if (!await _networkInfo.isConnected) throw const NetworkException();

    try {
      final response = await _dio.post(
        Endpoints.productsAdd,
        data: requestModel.toJson(),
      );
      return PaymentModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  /// Converts DioException to typed exceptions.
  /// DummyJSON uses "message" not "error" — confirmed in Postman Day 2.
  Never _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      throw const NetworkException();
    }

    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    if (statusCode == 404) {
      final message = data is Map
          ? (data['message'] ?? 'Payment not found')
          : 'Payment not found';
      throw ServerException(message: message as String, statusCode: 404);
    }

    throw ServerException(
      message: 'Server error. Please try again later.',
      statusCode: statusCode,
    );
  }
}