import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/network/network_info.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(
    @Named('dummyjson') this._dio,
    this._networkInfo,
  );

  final Dio _dio;
  final NetworkInfo _networkInfo;

  @override
  Future<ProfileModel> getProfile() async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkException();
    }

    try {
      final response = await _dio.get(Endpoints.user);
      return ProfileModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw const NetworkException();
      }
      throw ServerException(
        message: 'Could not load profile. Please try again.',
        statusCode: e.response?.statusCode,
      );
    }
  }
}