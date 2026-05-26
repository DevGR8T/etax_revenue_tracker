import 'package:flutter_test/flutter_test.dart';
import 'package:etax_revenue_tracker/core/security/input_validator.dart';

void main() {
  group('InputValidator', () {
    group('email', () {
      test('returns null for valid email', () {
        expect(InputValidator.email('test@example.com'), null);
      });

      test('returns error for empty email', () {
        expect(InputValidator.email(''), isNotNull);
      });

      test('returns error for email without @', () {
        expect(InputValidator.email('testexample.com'), isNotNull);
      });

      test('returns error for email without domain', () {
        expect(InputValidator.email('test@'), isNotNull);
      });

      test('returns error for null', () {
        expect(InputValidator.email(null), isNotNull);
      });

      test('accepts valid Nigerian email', () {
        expect(
          InputValidator.email('testcitizen@etax.ng'),
          null,
        );
      });
    });

    group('password', () {
      test('returns null for strong password', () {
        expect(InputValidator.password('Password1'), null);
      });

      test('returns error for too short password', () {
        expect(InputValidator.password('Pass1'), isNotNull);
      });

      test('returns error for password without number', () {
        expect(InputValidator.password('Password'), isNotNull);
      });

      test('returns error for password without uppercase', () {
        expect(InputValidator.password('password1'), isNotNull);
      });

      test('returns error for empty password', () {
        expect(InputValidator.password(''), isNotNull);
      });

      test('returns error for null', () {
        expect(InputValidator.password(null), isNotNull);
      });
    });

    group('phoneNumber', () {
      test('returns null for valid 080 number', () {
        expect(
          InputValidator.phoneNumber('08012345678'),
          null,
        );
      });

      test('returns null for valid +234 number', () {
        expect(
          InputValidator.phoneNumber('+2348012345678'),
          null,
        );
      });

      test('returns error for invalid number', () {
        expect(
          InputValidator.phoneNumber('12345'),
          isNotNull,
        );
      });

      test('returns error for empty', () {
        expect(InputValidator.phoneNumber(''), isNotNull);
      });
    });

    group('amount', () {
      test('returns null for valid amount', () {
        expect(InputValidator.amount('5000'), null);
      });

      test('returns error for zero', () {
        expect(InputValidator.amount('0'), isNotNull);
      });

      test('returns error for negative', () {
        expect(InputValidator.amount('-100'), isNotNull);
      });

      test('returns error for above maximum', () {
        expect(InputValidator.amount('10000001'), isNotNull);
      });

      test('returns error for non-numeric', () {
        expect(InputValidator.amount('abc'), isNotNull);
      });

      test('returns error for empty', () {
        expect(InputValidator.amount(''), isNotNull);
      });

      test('accepts maximum allowed value', () {
        expect(InputValidator.amount('10000000'), null);
      });
    });

    group('passwordStrength', () {
      test('returns 0 for empty password', () {
        expect(InputValidator.passwordStrength(''), 0);
      });

      test('returns 0 for short password with no qualifying criteria', () {
        /// 'pass' is under 8 chars, no number, no uppercase — scores 0
        expect(InputValidator.passwordStrength('pass'), 0);
      });

      test('returns 1 for password with only length >= 8', () {
        /// 'password' — 8 chars, no number, no uppercase — scores 1
        expect(InputValidator.passwordStrength('password'), 1);
      });

      test('returns 2 for password with length and number', () {
        /// 'password1' — 8 chars + number, no uppercase — scores 2
        expect(InputValidator.passwordStrength('password1'), 2);
      });

      test('returns 3 for strong password', () {
        /// 'Password1' — 8 chars + number + uppercase — scores 3
        expect(
          InputValidator.passwordStrength('Password1'),
          3,
        );
      });
    });

    group('confirmPassword', () {
      test('returns null when passwords match', () {
        expect(
          InputValidator.confirmPassword('Password1', 'Password1'),
          null,
        );
      });

      test('returns error when passwords do not match', () {
        expect(
          InputValidator.confirmPassword('Password1', 'Password2'),
          isNotNull,
        );
      });

      test('returns error for empty confirm', () {
        expect(
          InputValidator.confirmPassword('', 'Password1'),
          isNotNull,
        );
      });
    });
  });
}