
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:etax_revenue_tracker/core/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: widget,
      ),
    );
  }
}