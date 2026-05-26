import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:etax_revenue_tracker/features/payments/domain/entities/payment_status.dart';
import 'package:etax_revenue_tracker/features/payments/presentation/widgets/status_badge.dart';
import 'package:etax_revenue_tracker/core/constants/app_colors.dart';
import 'package:etax_revenue_tracker/core/theme/app_theme.dart';

/// Helper — pumps widget directly without MultiBlocProvider.
Future<void> pumpBadge(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: Center(child: widget)),
    ),
  );
}

void main() {
  group('StatusBadge', () {
    testWidgets(
      'shows Paid label for paid status',
      (tester) async {
        await pumpBadge(
          tester,
          const StatusBadge(status: PaymentStatus.paid),
        );
        expect(find.text('Paid'), findsOneWidget);
      },
    );

    testWidgets(
      'shows Pending label for pending status',
      (tester) async {
        await pumpBadge(
          tester,
          const StatusBadge(status: PaymentStatus.pending),
        );
        expect(find.text('Pending'), findsOneWidget);
      },
    );

    testWidgets(
      'shows Failed label for failed status',
      (tester) async {
        await pumpBadge(
          tester,
          const StatusBadge(status: PaymentStatus.failed),
        );
        expect(find.text('Failed'), findsOneWidget);
      },
    );

    testWidgets(
      'paid badge has green background',
      (tester) async {
        await pumpBadge(
          tester,
          const StatusBadge(status: PaymentStatus.paid),
        );
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, AppColors.paidBackground);
      },
    );

    testWidgets(
      'pending badge has amber background',
      (tester) async {
        await pumpBadge(
          tester,
          const StatusBadge(status: PaymentStatus.pending),
        );
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, AppColors.pendingBackground);
      },
    );

    testWidgets(
      'failed badge has red background',
      (tester) async {
        await pumpBadge(
          tester,
          const StatusBadge(status: PaymentStatus.failed),
        );
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, AppColors.failedBackground);
      },
    );
  });
}