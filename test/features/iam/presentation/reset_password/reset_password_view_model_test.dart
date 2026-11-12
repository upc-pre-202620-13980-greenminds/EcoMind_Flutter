import 'dart:async';

import 'package:ecomind_parents/features/iam/application/confirm_password_recovery_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_state.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResetPasswordViewModel', () {
    const token = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';

    test('malformed link cannot submit a password', () async {
      final repository = _AuthRepositoryFake();
      final sessions = _SessionRepositoryFake();
      final model = _viewModel(repository, sessions)..openLink(null);
      addTearDown(model.dispose);

      expect(model.state.linkStatus, ResetLinkStatus.malformed);
      model.onPasswordChange('Healthy123');
      model.onConfirmPasswordChange('Healthy123');
      await model.submit();

      expect(repository.confirmed, isEmpty);
      expect(sessions.clearCount, 0);
    });

    test('weak or mismatched passwords are rejected locally', () async {
      final repository = _AuthRepositoryFake();
      final sessions = _SessionRepositoryFake();
      final model = _viewModel(repository, sessions)..openLink(token);
      addTearDown(model.dispose);

      model.onPasswordChange('1234567');
      model.onConfirmPasswordChange('7654321');
      await model.submit();

      expect(repository.confirmed, isEmpty);
      expect(model.state.passwordError, FieldError.passwordPolicy);
      expect(model.state.confirmPasswordError, FieldError.passwordMismatch);
      expect(sessions.clearCount, 0);
    });

    test('valid reset clears local credentials only after success and forgets secrets', () async {
      final repository = _AuthRepositoryFake();
      final sessions = _SessionRepositoryFake();
      final pending = Completer<void>();
      repository.confirmHandler = (_, _) => pending.future;
      final model = _viewModel(repository, sessions)..openLink(token);
      addTearDown(model.dispose);
      model.onPasswordChange('Healthy123');
      model.onConfirmPasswordChange('Healthy123');

      final first = model.submit();
      final duplicate = model.submit();
      expect(repository.confirmed, [(token, 'Healthy123')]);
      expect(sessions.clearCount, 0);
      expect(model.state.isLoading, isTrue);

      pending.complete();
      await Future.wait([first, duplicate]);

      expect(sessions.clearCount, 1);
      expect(model.state.isCompleted, isTrue);
      expect(model.state.password, isEmpty);
      expect(model.state.confirmPassword, isEmpty);
      expect(model.state.toString(), isNot(contains('Healthy123')));
      await model.submit();
      expect(repository.confirmed, hasLength(1));
      expect(sessions.clearCount, 1);
    });

    test('invalid or consumed token shows rejected-link state without clearing session', () async {
      final repository = _AuthRepositoryFake()
        ..confirmHandler = (_, _) async {
          throw const AuthException(AuthError.resetTokenInvalid);
        };
      final sessions = _SessionRepositoryFake();
      final model = _viewModel(repository, sessions)..openLink(token);
      addTearDown(model.dispose);
      model.onPasswordChange('Healthy123');
      model.onConfirmPasswordChange('Healthy123');

      await model.submit();

      expect(model.state.linkStatus, ResetLinkStatus.rejected);
      expect(model.state.isLinkInvalid, isTrue);
      expect(model.state.password, isEmpty);
      expect(model.state.confirmPassword, isEmpty);
      expect(sessions.clearCount, 0);
    });

    test('connection failure preserves fields and can be retried', () async {
      final repository = _AuthRepositoryFake();
      repository.confirmHandler = (_, _) async {
        if (repository.confirmed.length == 1) {
          throw const AuthException(AuthError.connection);
        }
      };
      final sessions = _SessionRepositoryFake();
      final model = _viewModel(repository, sessions)..openLink(token);
      addTearDown(model.dispose);
      model.onPasswordChange('Healthy123');
      model.onConfirmPasswordChange('Healthy123');

      await model.submit();
      expect(model.state.errorMessage, AuthError.connection);
      expect(model.state.password, 'Healthy123');
      expect(model.state.confirmPassword, 'Healthy123');
      expect(sessions.clearCount, 0);

      await model.submit();
      expect(repository.confirmed, [
        (token, 'Healthy123'),
        (token, 'Healthy123'),
      ]);
      expect(model.state.isCompleted, isTrue);
      expect(sessions.clearCount, 1);
    });

    test('server password-policy rejection keeps the form editable', () async {
      final repository = _AuthRepositoryFake()
        ..confirmHandler = (_, _) async {
          throw const AuthException(AuthError.passwordPolicy);
        };
      final sessions = _SessionRepositoryFake();
      final model = _viewModel(repository, sessions)..openLink(token);
      addTearDown(model.dispose);
      model.onPasswordChange('Healthy123');
      model.onConfirmPasswordChange('Healthy123');

      await model.submit();

      expect(model.state.passwordError, FieldError.passwordPolicy);
      expect(model.state.password, 'Healthy123');
      expect(model.state.confirmPassword, 'Healthy123');
      expect(sessions.clearCount, 0);
    });
  });
}

ResetPasswordViewModel _viewModel(
  _AuthRepositoryFake repository,
  _SessionRepositoryFake sessions,
) => ResetPasswordViewModel(
  confirmPasswordRecovery: ConfirmPasswordRecoveryUseCase(
    authRepository: repository,
    sessionRepository: sessions,
  ),
);

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
