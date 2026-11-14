import 'package:ecomind_parents/features/iam/navigation/password_reset_link.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasswordResetLink', () {
    const token = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';

    test('accepts the exact EcoMind reset route and returns its token', () {
      final uri = Uri.parse(
        'ecomind://authentication/reset-password?token=$token',
      );

      expect(PasswordResetLink.matches(uri), isTrue);
      expect(PasswordResetLink.tokenFrom(uri), token);
    });

    test('identifies a matching route with a missing or malformed token', () {
      final missing = Uri.parse('ecomind://authentication/reset-password');
      final malformed = Uri.parse(
        'ecomind://authentication/reset-password?token=short',
      );

      expect(PasswordResetLink.matches(missing), isTrue);
      expect(PasswordResetLink.tokenFrom(missing), isNull);
      expect(PasswordResetLink.matches(malformed), isTrue);
      expect(PasswordResetLink.tokenFrom(malformed), isNull);
    });

    test('rejects other schemes, hosts, and paths', () {
      for (final uri in [
        Uri.parse('https://authentication/reset-password?token=$token'),
        Uri.parse('ecomind://elsewhere/reset-password?token=$token'),
        Uri.parse('ecomind://authentication/other?token=$token'),
      ]) {
        expect(PasswordResetLink.matches(uri), isFalse, reason: '$uri');
        expect(PasswordResetLink.tokenFrom(uri), isNull, reason: '$uri');
      }
    });

    test('rejects user info, explicit ports, and fragments', () {
      for (final uri in [
        Uri.parse('ecomind://user@authentication/reset-password?token=$token'),
        Uri.parse('ecomind://authentication:8080/reset-password?token=$token'),
        Uri.parse('ecomind://authentication/reset-password?token=$token#extra'),
      ]) {
        expect(PasswordResetLink.matches(uri), isTrue, reason: '$uri');
        expect(PasswordResetLink.tokenFrom(uri), isNull, reason: '$uri');
      }
    });

    test('rejects duplicate token parameters, including identical values', () {
      for (final uri in [
        Uri.parse(
          'ecomind://authentication/reset-password?token=$token&token=BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',
        ),
        Uri.parse(
          'ecomind://authentication/reset-password?token=$token&token=$token',
        ),
      ]) {
        expect(PasswordResetLink.matches(uri), isTrue, reason: '$uri');
        expect(PasswordResetLink.tokenFrom(uri), isNull, reason: '$uri');
      }
    });

    test('rejects padded, non-base64url, and wrong-length tokens', () {
      for (final badToken in [
        '$token=',
        '${token.substring(0, 42)}+',
        token.substring(0, 42),
        token.padRight(44, 'A'),
      ]) {
        final uri = Uri.parse(
          'ecomind://authentication/reset-password?token=$badToken',
        );
        expect(PasswordResetLink.tokenFrom(uri), isNull, reason: badToken);
      }
    });

    test('does not require or act on unrelated query parameters', () {
      final uri = Uri.parse(
        'ecomind://authentication/reset-password?token=$token&next=https%3A%2F%2Fexample.invalid',
      );

      expect(PasswordResetLink.matches(uri), isTrue);
      expect(PasswordResetLink.tokenFrom(uri), token);
    });
  });
}
