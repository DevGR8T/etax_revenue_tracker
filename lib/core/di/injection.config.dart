// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:etax_revenue_tracker/core/di/injection.dart' as _i499;
import 'package:etax_revenue_tracker/core/network/dio_client.dart' as _i454;
import 'package:etax_revenue_tracker/core/network/network_info.dart' as _i510;
import 'package:etax_revenue_tracker/core/security/biometric_service.dart'
    as _i816;
import 'package:etax_revenue_tracker/core/services/auth_service.dart' as _i179;
import 'package:etax_revenue_tracker/core/services/supabase_service.dart'
    as _i269;
import 'package:etax_revenue_tracker/features/auth/data/datasources/auth_local_datasource.dart'
    as _i910;
import 'package:etax_revenue_tracker/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i1061;
import 'package:etax_revenue_tracker/features/auth/data/repositories/auth_repository_impl.dart'
    as _i98;
import 'package:etax_revenue_tracker/features/auth/domain/repositories/auth_repository.dart'
    as _i956;
import 'package:etax_revenue_tracker/features/auth/domain/usecases/login_usecase.dart'
    as _i698;
import 'package:etax_revenue_tracker/features/auth/domain/usecases/logout_usecase.dart'
    as _i457;
import 'package:etax_revenue_tracker/features/auth/domain/usecases/register_usecase.dart'
    as _i759;
import 'package:etax_revenue_tracker/features/auth/domain/usecases/reset_password_usecase.dart'
    as _i247;
import 'package:etax_revenue_tracker/features/auth/domain/usecases/send_reset_link_usecase.dart'
    as _i472;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final externalModule = _$ExternalModule();
    final dioModule = _$DioModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => externalModule.secureStorage,
    );
    gh.lazySingleton<_i895.Connectivity>(() => externalModule.connectivity);
    gh.lazySingleton<_i152.LocalAuthentication>(() => externalModule.localAuth);
    gh.lazySingleton<_i816.BiometricService>(
      () => _i816.BiometricService(gh<_i152.LocalAuthentication>()),
    );
    gh.lazySingleton<_i269.SupabaseService>(
      () => _i269.SupabaseService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i510.NetworkInfo>(
      () => _i510.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i1061.AuthRemoteDataSource>(
      () => _i1061.AuthRemoteDataSourceImpl(
        gh<_i269.SupabaseService>(),
        gh<_i510.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i179.AuthService>(
      () => _i179.AuthService(gh<_i269.SupabaseService>()),
    );
    gh.lazySingleton<_i910.AuthLocalDataSource>(
      () => _i910.AuthLocalDataSourceImpl(gh<_i269.SupabaseService>()),
    );
    gh.lazySingleton<_i956.AuthRepository>(
      () => _i98.AuthRepositoryImpl(
        gh<_i1061.AuthRemoteDataSource>(),
        gh<_i910.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i759.RegisterUseCase>(
      () => _i759.RegisterUseCase(gh<_i956.AuthRepository>()),
    );
    gh.factory<_i698.LoginUseCase>(
      () => _i698.LoginUseCase(gh<_i956.AuthRepository>()),
    );
    gh.factory<_i457.LogoutUseCase>(
      () => _i457.LogoutUseCase(gh<_i956.AuthRepository>()),
    );
    gh.factory<_i247.ResetPasswordUseCase>(
      () => _i247.ResetPasswordUseCase(gh<_i956.AuthRepository>()),
    );
    gh.factory<_i472.SendResetLinkUseCase>(
      () => _i472.SendResetLinkUseCase(gh<_i956.AuthRepository>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dummyJsonDio(gh<_i179.AuthService>()),
      instanceName: 'dummyjson',
    );
    return this;
  }
}

class _$ExternalModule extends _i499.ExternalModule {}

class _$DioModule extends _i454.DioModule {}
