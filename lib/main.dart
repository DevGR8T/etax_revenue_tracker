import 'package:etax_revenue_tracker/core/services/notification_service.dart';
import 'package:etax_revenue_tracker/core/services/supabase_service.dart';
import 'package:etax_revenue_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:etax_revenue_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:etax_revenue_tracker/features/auth/presentation/bloc/forgot_password_cubit.dart';
import 'package:etax_revenue_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:etax_revenue_tracker/features/payments/presentation/bloc/pay_tax_bloc.dart';
import 'package:etax_revenue_tracker/features/payments/presentation/bloc/payment_detail_bloc.dart';
import 'package:etax_revenue_tracker/features/payments/presentation/bloc/payment_history_bloc.dart';
import 'package:etax_revenue_tracker/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:etax_revenue_tracker/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/config/flavor_config.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

    // Initialize Firebase — must happen before GetIt setup
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  // Register background FCM handler
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

    // Initialise Supabase before GetIt
  await SupabaseService.initialize();

  // Hydrated bloc — persists theme across restarts
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );


  // Register all dependencies
  await setupGetIt();

    // Initialize notification service
  await getIt<NotificationService>().initialize();


  // Fire initial auth check after GetIt is ready
  getIt<AuthBloc>().add(const CheckAuthStatusEvent());

  // Sentry error tracking — wraps the entire app
  await SentryFlutter.init((options) {
    options.dsn = dotenv.env['SENTRY_DSN'] ?? '';
    options.tracesSampleRate = FlavorConfig.isProduction ? 0.2 : 1.0;
    options.environment = FlavorConfig.flavor.name;
    // Scrub PII from all error reports
    options.beforeSend = (event, hint) {
      event.user = null; //so it never sends any user info to Sentry
      return event;
    };
  }, appRunner: () => runApp(const EtaxApp()));
}

class EtaxApp extends StatelessWidget {
  const EtaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
        BlocProvider<ForgotPasswordCubit>(
          create: (_) => getIt<ForgotPasswordCubit>(),
        ),
        BlocProvider<DashboardBloc>(create: (_) => getIt<DashboardBloc>()),
        BlocProvider<PaymentHistoryBloc>(
          create: (_) => getIt<PaymentHistoryBloc>(),
        ),
        BlocProvider<PaymentDetailBloc>(
          create: (_) => getIt<PaymentDetailBloc>(),
        ),
        BlocProvider<PayTaxBloc>(create: (_) => getIt<PayTaxBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => getIt<ProfileBloc>()),
      ],
      child: MaterialApp.router(
        title: 'eTax Revenue Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
      ),
    );
  }
}
