import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:etax_revenue_tracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:etax_revenue_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:etax_revenue_tracker/features/auth/presentation/bloc/auth_state.dart';
import 'package:etax_revenue_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:etax_revenue_tracker/core/theme/app_theme.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  late MockAuthBloc mockBloc;

  setUp(() {
    mockBloc = MockAuthBloc();
    when(() => mockBloc.state).thenReturn(const AuthInitialState());
  });

  /// Helper — pumps LoginScreen with AuthBloc provided.
  /// No MultiBlocProvider — avoids empty providers crash.
  Future<void> pumpLoginScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: BlocProvider<AuthBloc>.value(
          value: mockBloc,
          child: const LoginScreen(),
        ),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets(
      'renders email and password fields',
      (tester) async {
        await pumpLoginScreen(tester);
        expect(find.byType(TextFormField), findsNWidgets(2));
      },
    );

    testWidgets(
      'renders Sign In button',
      (tester) async {
        await pumpLoginScreen(tester);
        expect(find.text('Sign in'), findsOneWidget);
      },
    );

    testWidgets(
      'shows loading spinner when AuthLoadingState',
      (tester) async {
        when(() => mockBloc.state)
            .thenReturn(const AuthLoadingState());

        await pumpLoginScreen(tester);

        expect(
          find.byType(CircularProgressIndicator),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows validation error when submitting empty email',
      (tester) async {
        await pumpLoginScreen(tester);

        await tester.tap(find.text('Sign in'));
        await tester.pump();

        expect(
          find.text('This field is required'),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'sign in button is disabled during loading state',
      (tester) async {
        when(() => mockBloc.state)
            .thenReturn(const AuthLoadingState());

        await pumpLoginScreen(tester);

        final button = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(button.onPressed, isNull);
      },
    );
  });
}