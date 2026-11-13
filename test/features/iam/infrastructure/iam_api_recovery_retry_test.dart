import 'dart:convert';
import 'dart:io';

import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/iam/infrastructure/remote/iam_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  const token = 'test-recovery-token';
  const newPassword = 'test-new-password';
  final confirmationId = List<String>.filled(43, 'c').join();

  group('confirmPasswordRecovery transport retry', () {
    test(
      'retries a committed request after its first response is lost',
      () async {
        var committed = false;
        final bodies = <String>[];
        final clients = <_RecordingClient>[];
        final api = IamApi(
          confirmationTimeout: const Duration(seconds: 2),
          clientFactory: () {
            final client = _RecordingClient((request, body) async {
              bodies.add(body);
              final decoded = jsonDecode(body) as Map<String, dynamic>;
              expect(decoded['confirmationId'], confirmationId);
              expect(decoded['token'], token);
              expect(decoded['newPassword'], newPassword);

              if (bodies.length == 1) {
                // The server commits before the connection drops the response.
                committed = true;
                throw const SocketException('simulated response loss');
              }

              expect(committed, isTrue);
              return _response(HttpStatus.noContent);
            });
            clients.add(client);
            return client;
          },
        );

        await api.confirmPasswordRecovery(
          token,
          newPassword,
          confirmationId: confirmationId,
        );

        expect(bodies, hasLength(2));
        expect(bodies[1], bodies[0]);
        expect(clients, hasLength(2));
        expect(clients.map((client) => client.closed), everyElement(isTrue));
      },
    );

    test('retries after the first attempt times out', () async {
      var attempts = 0;
      final clients = <_RecordingClient>[];
      final api = IamApi(
        confirmationTimeout: const Duration(milliseconds: 100),
        clientFactory: () {
          final client = _RecordingClient((request, body) async {
            attempts++;
            if (attempts == 1) {
              await Future<void>.delayed(const Duration(milliseconds: 150));
            }
            return _response(HttpStatus.noContent);
          });
          clients.add(client);
          return client;
        },
      );

      await api.confirmPasswordRecovery(
        token,
        newPassword,
        confirmationId: confirmationId,
      );

      expect(attempts, 2);
      expect(clients, hasLength(2));
      expect(clients.map((client) => client.closed), everyElement(isTrue));
    });

    test('retries a 502 response and accepts the later 204', () async {
      var attempts = 0;
      final bodies = <String>[];
      final clients = <_RecordingClient>[];
      final api = IamApi(
        confirmationTimeout: const Duration(seconds: 2),
        clientFactory: () {
          final client = _RecordingClient((request, body) async {
            attempts++;
            bodies.add(body);
            if (attempts == 1) {
              return _response(
                HttpStatus.badGateway,
                body: jsonEncode({'code': 'SERVICE_UNAVAILABLE'}),
              );
            }
            return _response(HttpStatus.noContent);
          });
          clients.add(client);
          return client;
        },
      );

      await api.confirmPasswordRecovery(
        token,
        newPassword,
        confirmationId: confirmationId,
      );

      expect(attempts, 2);
      expect(bodies[1], bodies[0]);
      expect(clients.map((client) => client.closed), everyElement(isTrue));
    });

    for (final statusCode in [
      HttpStatus.badRequest,
      HttpStatus.unprocessableEntity,
    ]) {
      test('does not retry definitive HTTP $statusCode errors', () async {
        var attempts = 0;
        final clients = <_RecordingClient>[];
        final api = IamApi(
          confirmationTimeout: const Duration(seconds: 2),
          clientFactory: () {
            final client = _RecordingClient((request, body) async {
              attempts++;
              return _response(
                statusCode,
                body: jsonEncode({'code': 'PASSWORD_RESET_TOKEN_INVALID'}),
              );
            });
            clients.add(client);
            return client;
          },
        );

        await expectLater(
          api.confirmPasswordRecovery(
            token,
            newPassword,
            confirmationId: confirmationId,
          ),
          throwsA(
            isA<ApiException>().having(
              (error) => error.statusCode,
              'statusCode',
              statusCode,
            ),
          ),
        );

        expect(attempts, 1);
        expect(clients.single.closed, isTrue);
      });
    }

    test('propagates the connection error when both attempts fail', () async {
      var attempts = 0;
      final clients = <_RecordingClient>[];
      final api = IamApi(
        confirmationTimeout: const Duration(seconds: 2),
        clientFactory: () {
          final client = _RecordingClient((request, body) async {
            attempts++;
            throw const SocketException('simulated connection failure');
          });
          clients.add(client);
          return client;
        },
      );

      await expectLater(
        api.confirmPasswordRecovery(
          token,
          newPassword,
          confirmationId: confirmationId,
        ),
        throwsA(isA<SocketException>()),
      );

      expect(attempts, 2);
      expect(clients.map((client) => client.closed), everyElement(isTrue));
    });

    test('does not retry a consumed-token 422 response', () async {
      var attempts = 0;
      final clients = <_RecordingClient>[];
      final api = IamApi(
        confirmationTimeout: const Duration(seconds: 2),
        clientFactory: () {
          final client = _RecordingClient((request, body) async {
            attempts++;
            return _response(
              HttpStatus.unprocessableEntity,
              body: jsonEncode({'code': 'TOKEN_ALREADY_USED'}),
            );
          });
          clients.add(client);
          return client;
        },
      );

      await expectLater(
        api.confirmPasswordRecovery(
          token,
          newPassword,
          confirmationId: confirmationId,
        ),
        throwsA(
          isA<ApiException>()
              .having((error) => error.statusCode, 'statusCode', 422)
              .having((error) => error.code, 'code', 'TOKEN_ALREADY_USED'),
        ),
      );

      expect(attempts, 1);
      expect(clients, hasLength(1));
      expect(clients.single.closed, isTrue);
    });

    test(
      'preserves the original transport error if retry receives 422',
      () async {
        var attempts = 0;
        final clients = <_RecordingClient>[];
        final api = IamApi(
          confirmationTimeout: const Duration(seconds: 2),
          clientFactory: () {
            final client = _RecordingClient((request, body) async {
              attempts++;
              if (attempts == 1) {
                throw const SocketException('simulated lost response');
              }
              return _response(
                HttpStatus.unprocessableEntity,
                body: jsonEncode({'code': 'TOKEN_ALREADY_USED'}),
              );
            });
            clients.add(client);
            return client;
          },
        );

        await expectLater(
          api.confirmPasswordRecovery(
            token,
            newPassword,
            confirmationId: confirmationId,
          ),
          throwsA(isA<SocketException>()),
        );

        expect(attempts, 2);
        expect(clients, hasLength(2));
        expect(clients.map((client) => client.closed), everyElement(isTrue));
      },
    );

    test('keeps the legacy no-ID request to one attempt', () async {
      var attempts = 0;
      final clients = <_RecordingClient>[];
      final bodies = <String>[];
      final api = IamApi(
        confirmationTimeout: const Duration(seconds: 2),
        clientFactory: () {
          final client = _RecordingClient((request, body) async {
            attempts++;
            bodies.add(body);
            throw const SocketException('simulated connection failure');
          });
          clients.add(client);
          return client;
        },
      );

      await expectLater(
        api.confirmPasswordRecovery(token, newPassword),
        throwsA(isA<SocketException>()),
      );

      expect(attempts, 1);
      expect(clients.single.closed, isTrue);
      final decoded = jsonDecode(bodies.single) as Map<String, dynamic>;
      expect(decoded, containsPair('token', token));
      expect(decoded, containsPair('newPassword', newPassword));
      expect(decoded, isNot(contains('confirmationId')));
    });
  });
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

class _RecordingClient extends http.BaseClient {
  _RecordingClient(this._handler);

  final _SendHandler _handler;
  bool closed = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = await request.finalize().bytesToString();
    return _handler(request, body);
  }

  @override
  void close() {
    closed = true;
  }
}
