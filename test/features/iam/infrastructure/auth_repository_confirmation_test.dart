import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/infrastructure/auth_repository_impl.dart';
import 'package:ecomind_parents/features/iam/infrastructure/remote/iam_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  const token = 'test-recovery-token';
  const password = 'test-new-password';
  final confirmationId = List<String>.filled(43, 'c').join();

  group('AuthRepositoryImpl recovery confirmation errors', () {
    test('maps timeout to resetOutcomeUnknown', () async {
      await _expectUnknown(TimeoutException('simulated timeout'));
    });

    test('maps socket errors to resetOutcomeUnknown', () async {
      await _expectUnknown(const SocketException('simulated socket error'));
    });

    test('maps TLS errors to resetOutcomeUnknown', () async {
      await _expectUnknown(TlsException('simulated TLS error'));
    });

    test('maps HTTP client errors to resetOutcomeUnknown', () async {
      await _expectUnknown(http.ClientException('simulated client error'));
    });

    test('maps exhausted 502 responses to resetOutcomeUnknown', () async {
      var attempts = 0;
      final repository = AuthRepositoryImpl(
        api: IamApi(
          confirmationTimeout: const Duration(seconds: 2),
          clientFactory: () => _RepositoryClient((request, body) async {
            attempts++;
            return _response(
              HttpStatus.badGateway,
              body: jsonEncode({'code': 'SERVICE_UNAVAILABLE'}),
            );
          }),
        ),
      );

      await _expectAuthError(
        () => repository.confirmPasswordRecovery(
          token,
          password,
          confirmationId: confirmationId,
        ),
        AuthError.resetOutcomeUnknown,
      );
      expect(attempts, 2);
    });

    test('maps a definitive password policy error specifically', () async {
      final repository = AuthRepositoryImpl(
        api: IamApi(
          confirmationTimeout: const Duration(seconds: 2),
          clientFactory: () => _RepositoryClient((request, body) async {
            return _response(
              HttpStatus.badRequest,
              body: jsonEncode({'code': 'PASSWORD_POLICY_VIOLATION'}),
            );
          }),
        ),
      );

      await _expectAuthError(
        () => repository.confirmPasswordRecovery(
          token,
          password,
          confirmationId: confirmationId,
        ),
        AuthError.passwordPolicy,
      );
    });

    test('maps a definitive invalid token error specifically', () async {
      final repository = AuthRepositoryImpl(
        api: IamApi(
          confirmationTimeout: const Duration(seconds: 2),
          clientFactory: () => _RepositoryClient((request, body) async {
            return _response(
              HttpStatus.unprocessableEntity,
              body: jsonEncode({'code': 'PASSWORD_RESET_TOKEN_INVALID'}),
            );
          }),
        ),
      );

      await _expectAuthError(
        () => repository.confirmPasswordRecovery(
          token,
          password,
          confirmationId: confirmationId,
        ),
        AuthError.resetTokenInvalid,
      );
    });

    test(
      'keeps ordinary sign-in socket failures as connection errors',
      () async {
        final repository = AuthRepositoryImpl(api: IamApi());

        await _expectAuthError(
          () => repository.signIn('test@example.invalid', 'test-password'),
          AuthError.connection,
        );
      },
    );
  });
}

Future<void> _expectUnknown(Object error) async {
  var attempts = 0;
  final repository = AuthRepositoryImpl(
    api: IamApi(
      confirmationTimeout: const Duration(seconds: 2),
      clientFactory: () => _RepositoryClient((request, body) async {
        attempts++;
        throw error;
      }),
    ),
  );

  await _expectAuthError(
    () => repository.confirmPasswordRecovery(
      'test-recovery-token',
      'test-new-password',
      confirmationId: List<String>.filled(43, 'c').join(),
    ),
    AuthError.resetOutcomeUnknown,
  );
  expect(attempts, 2);
}

Future<void> _expectAuthError(
  Future<void> Function() action,
  AuthError expected,
) async {
  await expectLater(
    action(),
    throwsA(
      isA<AuthException>().having((error) => error.error, 'error', expected),
    ),
  );
}

http.StreamedResponse _response(int statusCode, {String body = ''}) {
  return http.StreamedResponse(
    Stream<List<int>>.value(utf8.encode(body)),
    statusCode,
  );
}

typedef _SendHandler = Future<http.StreamedResponse> Function(
  http.BaseRequest request,
  String body,
);

class _RepositoryClient extends http.BaseClient {
  _RepositoryClient(this._handler);

  final _SendHandler _handler;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = await request.finalize().bytesToString();
    return _handler(request, body);
  }
}
