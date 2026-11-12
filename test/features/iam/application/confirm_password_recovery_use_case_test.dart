import 'dart:async';

import 'package:ecomind_parents/features/iam/application/confirm_password_recovery_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConfirmPasswordRecoveryUseCase', () {
    test(
      'clears the local session only after the server confirms reset',
      () async {
        final token = List<String>.filled(43, 'A').join();
        final repository = _AuthRepositoryFake();
        final sessionStore = _SessionRepositoryFake();
        final pending = Completer<void>();
        repository.confirmHandler = (token, password) => pending.future;
        final useCase = ConfirmPasswordRecoveryUseCase(
          authRepository: repository,
          sessionRepository: sessionStore,
        );

        final reset = useCase.execute(token, 'Healthy123');
        expect(repository.confirmed, [(token, 'Healthy123')]);
        expect(sessionStore.clearCount, 0);

        pending.complete();
        await reset;
        expect(sessionStore.clearCount, 1);
      },
    );

    test('retains the local session when reset confirmation fails', () async {
      final token = List<String>.filled(43, 'B').join();
      final repository = _AuthRepositoryFake()
        ..confirmHandler = (_, _) async {
          throw const AuthException(AuthError.connection);
        };
      final sessionStore = _SessionRepositoryFake();
      final useCase = ConfirmPasswordRecoveryUseCase(
        authRepository: repository,
        sessionRepository: sessionStore,
      );

      await expectLater(
        useCase.execute(token, 'Healthy123'),
        throwsA(
          isA<AuthException>().having(
            (error) => error.error,
            'error',
            AuthError.connection,
          ),
        ),
      );
      expect(sessionStore.clearCount, 0);
    });
  });
}

class _AuthRepositoryFake implements AuthRepository {
  final List<(String, String)> confirmed = [];
  Future<void> Function(String token, String password)? confirmHandler;

  @override
  Future<void> confirmPasswordRecovery(String token, String newPassword) {
    confirmed.add((token, newPassword));
    return confirmHandler?.call(token, newPassword) ?? Future<void>.value();
  }

  @override
  Future<void> requestPasswordRecovery(
    String email, {
    String? languageTag,
  }) async {}

  @override
  Future<Session> signIn(String email, String password) async =>
      throw UnimplementedError();

  @override
  Future<SocialRole> getSocialRole(Session session) async =>
      throw UnimplementedError();

  @override
  Future<void> signUp(
    String name,
    String email,
    String password,
    SocialRole role,
  ) async => throw UnimplementedError();

  @override
  Future<void> verifyEmail(String email, String code) async =>
      throw UnimplementedError();

  @override
  Future<void> signOut(Session session) async => throw UnimplementedError();
}

class _SessionRepositoryFake implements SessionRepository {
  int clearCount = 0;

  @override
  Future<void> clearSession() async {
    clearCount += 1;
  }

  @override
  Future<Session?> getSession() async => null;

  @override
  Future<void> saveSession(Session session) async {}
}
