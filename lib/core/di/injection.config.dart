// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:etax_revenue_tracker/core/di/injection.dart' as _i499;
import 'package:etax_revenue_tracker/core/network/dio_client.dart' as _i454;
import 'package:etax_revenue_tracker/core/network/network_info.dart' as _i510;
import 'package:etax_revenue_tracker/core/security/biometric_service.dart'
    as _i816;
import 'package:etax_revenue_tracker/core/security/security_service.dart'
    as _i291;
import 'package:etax_revenue_tracker/core/services/auth_service.dart' as _i179;
import 'package:etax_revenue_tracker/core/services/notification_service.dart'
    as _i621;
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
import 'package:etax_revenue_tracker/features/auth/presentation/bloc/auth_bloc.dart'
    as _i802;
import 'package:etax_revenue_tracker/features/auth/presentation/bloc/forgot_password_cubit.dart'
    as _i765;
import 'package:etax_revenue_tracker/features/dashboard/data/datasources/dashboard_remote_datasource.dart'
    as _i654;
import 'package:etax_revenue_tracker/features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i357;
import 'package:etax_revenue_tracker/features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i519;
import 'package:etax_revenue_tracker/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart'
    as _i1025;
import 'package:etax_revenue_tracker/features/dashboard/domain/usecases/refresh_dashboard_usecase.dart'
    as _i184;
import 'package:etax_revenue_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i959;
import 'package:etax_revenue_tracker/features/payments/data/datasources/payment_remote_datasource.dart'
    as _i96;
import 'package:etax_revenue_tracker/features/payments/data/repositories/payment_repository_impl.dart'
    as _i443;
import 'package:etax_revenue_tracker/features/payments/domain/repositories/payment_repository.dart'
    as _i4;
import 'package:etax_revenue_tracker/features/payments/domain/usecases/create_payment_usecase.dart'
    as _i608;
import 'package:etax_revenue_tracker/features/payments/domain/usecases/get_payment_detail_usecase.dart'
    as _i917;
import 'package:etax_revenue_tracker/features/payments/domain/usecases/get_payments_usecase.dart'
    as _i130;
import 'package:etax_revenue_tracker/features/payments/domain/usecases/search_payments_usecase.dart'
    as _i930;
import 'package:etax_revenue_tracker/features/payments/presentation/bloc/pay_tax_bloc.dart'
    as _i610;
import 'package:etax_revenue_tracker/features/payments/presentation/bloc/payment_detail_bloc.dart'
    as _i1012;
import 'package:etax_revenue_tracker/features/payments/presentation/bloc/payment_history_bloc.dart'
    as _i982;
import 'package:etax_revenue_tracker/features/profile/data/datasources/notification_firestore_datasource.dart'
    as _i93;
import 'package:etax_revenue_tracker/features/profile/data/datasources/profile_local_datasource.dart'
    as _i128;
import 'package:etax_revenue_tracker/features/profile/data/datasources/profile_remote_datasource.dart'
    as _i809;
import 'package:etax_revenue_tracker/features/profile/data/repositories/notification_repository_impl.dart'
    as _i840;
import 'package:etax_revenue_tracker/features/profile/data/repositories/profile_repository_impl.dart'
    as _i380;
import 'package:etax_revenue_tracker/features/profile/domain/repositories/notification_repository.dart'
    as _i710;
import 'package:etax_revenue_tracker/features/profile/domain/repositories/profile_repository.dart'
    as _i228;
import 'package:etax_revenue_tracker/features/profile/domain/usecases/get_notifications_usecase.dart'
    as _i676;
import 'package:etax_revenue_tracker/features/profile/domain/usecases/get_profile_usecase.dart'
    as _i133;
import 'package:etax_revenue_tracker/features/profile/domain/usecases/get_unread_count_usecase.dart'
    as _i451;
import 'package:etax_revenue_tracker/features/profile/domain/usecases/mark_all_read_usecase.dart'
    as _i25;
import 'package:etax_revenue_tracker/features/profile/domain/usecases/mark_notification_read_usecase.dart'
    as _i32;
import 'package:etax_revenue_tracker/features/profile/domain/usecases/refresh_profile_usecase.dart'
    as _i471;
import 'package:etax_revenue_tracker/features/profile/domain/usecases/save_notification_usecase.dart'
    as _i763;
import 'package:etax_revenue_tracker/features/profile/presentation/bloc/notification_bloc.dart'
    as _i685;
import 'package:etax_revenue_tracker/features/profile/presentation/bloc/profile_bloc.dart'
    as _i685;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final externalModule = _$ExternalModule();
    final dioModule = _$DioModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => externalModule.secureStorage,
    );
    gh.lazySingleton<_i895.Connectivity>(() => externalModule.connectivity);
    gh.lazySingleton<_i152.LocalAuthentication>(() => externalModule.localAuth);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => externalModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i974.FirebaseFirestore>(() => externalModule.firestore);
    gh.lazySingleton<_i892.FirebaseMessaging>(
      () => externalModule.firebaseMessaging,
    );
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
      () => externalModule.localNotifications,
    );
    gh.lazySingleton<_i291.DeviceSecurityService>(
      () => _i291.DeviceSecurityService(),
    );
    gh.lazySingleton<_i128.ProfileLocalDataSource>(
      () => _i128.ProfileLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
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
    gh.lazySingleton<_i93.NotificationFirestoreDataSource>(
      () => _i93.NotificationFirestoreDataSourceImpl(
        gh<_i974.FirebaseFirestore>(),
        gh<_i269.SupabaseService>(),
      ),
    );
    gh.lazySingleton<_i956.AuthRepository>(
      () => _i98.AuthRepositoryImpl(
        gh<_i1061.AuthRemoteDataSource>(),
        gh<_i910.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i621.NotificationService>(
      () => _i621.NotificationService(
        gh<_i892.FirebaseMessaging>(),
        gh<_i163.FlutterLocalNotificationsPlugin>(),
        gh<_i974.FirebaseFirestore>(),
        gh<_i179.AuthService>(),
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
    gh.factory<_i765.ForgotPasswordCubit>(
      () => _i765.ForgotPasswordCubit(gh<_i472.SendResetLinkUseCase>()),
    );
    gh.lazySingleton<_i654.DashboardRemoteDataSource>(
      () => _i654.DashboardRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'dummyjson'),
        gh<_i510.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i710.NotificationRepository>(
      () => _i840.NotificationRepositoryImpl(
        gh<_i93.NotificationFirestoreDataSource>(),
      ),
    );
    gh.lazySingleton<_i96.PaymentRemoteDataSource>(
      () => _i96.PaymentRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'dummyjson'),
        gh<_i510.NetworkInfo>(),
      ),
    );
    gh.singleton<_i802.AuthBloc>(
      () => _i802.AuthBloc(
        gh<_i698.LoginUseCase>(),
        gh<_i759.RegisterUseCase>(),
        gh<_i457.LogoutUseCase>(),
        gh<_i956.AuthRepository>(),
      ),
    );
    gh.factory<_i676.GetNotificationsUseCase>(
      () => _i676.GetNotificationsUseCase(gh<_i710.NotificationRepository>()),
    );
    gh.factory<_i32.MarkNotificationReadUseCase>(
      () =>
          _i32.MarkNotificationReadUseCase(gh<_i710.NotificationRepository>()),
    );
    gh.factory<_i451.GetUnreadCountUseCase>(
      () => _i451.GetUnreadCountUseCase(gh<_i710.NotificationRepository>()),
    );
    gh.factory<_i763.SaveNotificationUseCase>(
      () => _i763.SaveNotificationUseCase(gh<_i710.NotificationRepository>()),
    );
    gh.factory<_i25.MarkAllReadUseCase>(
      () => _i25.MarkAllReadUseCase(gh<_i710.NotificationRepository>()),
    );
    gh.lazySingleton<_i519.DashboardRepository>(
      () => _i357.DashboardRepositoryImpl(
        gh<_i654.DashboardRemoteDataSource>(),
        gh<_i269.SupabaseService>(),
      ),
    );
    gh.lazySingleton<_i809.ProfileRemoteDataSource>(
      () => _i809.ProfileRemoteDataSourceImpl(
        gh<_i361.Dio>(instanceName: 'dummyjson'),
        gh<_i510.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i4.PaymentRepository>(
      () => _i443.PaymentRepositoryImpl(
        gh<_i96.PaymentRemoteDataSource>(),
        gh<_i269.SupabaseService>(),
      ),
    );
    gh.factory<_i184.RefreshDashboardUseCase>(
      () => _i184.RefreshDashboardUseCase(gh<_i519.DashboardRepository>()),
    );
    gh.factory<_i1025.GetDashboardDataUseCase>(
      () => _i1025.GetDashboardDataUseCase(gh<_i519.DashboardRepository>()),
    );
    gh.factory<_i930.SearchPaymentsUseCase>(
      () => _i930.SearchPaymentsUseCase(gh<_i4.PaymentRepository>()),
    );
    gh.factory<_i917.GetPaymentDetailUseCase>(
      () => _i917.GetPaymentDetailUseCase(gh<_i4.PaymentRepository>()),
    );
    gh.factory<_i130.GetPaymentsUseCase>(
      () => _i130.GetPaymentsUseCase(gh<_i4.PaymentRepository>()),
    );
    gh.factory<_i608.CreatePaymentUseCase>(
      () => _i608.CreatePaymentUseCase(gh<_i4.PaymentRepository>()),
    );
    gh.factory<_i959.DashboardBloc>(
      () => _i959.DashboardBloc(
        gh<_i1025.GetDashboardDataUseCase>(),
        gh<_i184.RefreshDashboardUseCase>(),
      ),
    );
    gh.factory<_i982.PaymentHistoryBloc>(
      () => _i982.PaymentHistoryBloc(
        gh<_i130.GetPaymentsUseCase>(),
        gh<_i930.SearchPaymentsUseCase>(),
      ),
    );
    gh.factory<_i610.PayTaxBloc>(
      () => _i610.PayTaxBloc(gh<_i608.CreatePaymentUseCase>()),
    );
    gh.lazySingleton<_i228.ProfileRepository>(
      () => _i380.ProfileRepositoryImpl(
        gh<_i809.ProfileRemoteDataSource>(),
        gh<_i128.ProfileLocalDataSource>(),
        gh<_i269.SupabaseService>(),
      ),
    );
    gh.factory<_i685.NotificationBloc>(
      () => _i685.NotificationBloc(
        gh<_i676.GetNotificationsUseCase>(),
        gh<_i32.MarkNotificationReadUseCase>(),
        gh<_i25.MarkAllReadUseCase>(),
        gh<_i451.GetUnreadCountUseCase>(),
      ),
    );
    gh.factory<_i133.GetProfileUseCase>(
      () => _i133.GetProfileUseCase(gh<_i228.ProfileRepository>()),
    );
    gh.factory<_i471.RefreshProfileUseCase>(
      () => _i471.RefreshProfileUseCase(gh<_i228.ProfileRepository>()),
    );
    gh.factory<_i685.ProfileBloc>(
      () => _i685.ProfileBloc(
        gh<_i133.GetProfileUseCase>(),
        gh<_i471.RefreshProfileUseCase>(),
      ),
    );
    gh.factory<_i1012.PaymentDetailBloc>(
      () => _i1012.PaymentDetailBloc(gh<_i917.GetPaymentDetailUseCase>()),
    );
    return this;
  }
}

class _$ExternalModule extends _i499.ExternalModule {}

class _$DioModule extends _i454.DioModule {}
