import 'dart:async';

import 'package:ecomind_parents/features/iam/application/request_password_recovery_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_request/password_recovery_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasswordRecoveryViewModel', () {
    test(
      'normalizes a valid address and gives one generic acknowledgment',
      () async {
        final repository = _AuthRepositoryFake();
        final model = _viewModel(repository);
        addTearDown(model.dispose);

        model.onEmailChange('  Parent+home@Example.COM  ');
        await model.submit(languageTag: 'es-419');

        expect(repository.requestedEmails, ['parent+home@example.com']);
        expect(repository.requestedLanguages, ['es-419']);
        expect(model.state.isSent, isTrue);
        expect(model.state.errorMessage, isNull);
      },
    );

    test('rejects invalid email locally without sending a request', () async {
      final repository = _AuthRepositoryFake();
      final model = _viewModel(repository);
      addTearDown(model.dispose);

      model.onEmailChange('not an email');
      await model.submit();

      expect(repository.requestedEmails, isEmpty);
      expect(model.state.isSent, isFalse);
      expect(model.state.email, 'not an email');
      expect(model.state.emailError, FieldError.emailInvalid);
    });

    test(
      'suppresses a duplicate submit while the first request is pending',
      () async {
        final repository = _AuthRepositoryFake();
        final pending = Completer<void>();
        repository.requestHandler = (_) => pending.future;
        final model = _viewModel(repository);
        addTearDown(model.dispose);
        model.onEmailChange('parent@example.com');

        final first = model.submit();
        final second = model.submit();
        expect(model.state.isLoading, isTrue);
        expect(repository.requestedEmails, ['parent@example.com']);

        pending.complete();
        await Future.wait([first, second]);
        expect(model.state.isSent, isTrue);
        expect(model.state.isLoading, isFalse);
      },
    );

    test(
      'preserves the entered address after a connection error and allows retry',
      () async {
        final repository = _AuthRepositoryFake();
        repository.requestHandler = (_) async {
          if (repository.requestedEmails.length == 1) {
            throw const AuthException(AuthError.connection);
          }
        };
        final model = _viewModel(repository);
        addTearDown(model.dispose);
        model.onEmailChange('parent@example.com');

        await model.submit();
        expect(model.state.email, 'parent@example.com');
        expect(model.state.isSent, isFalse);
        expect(model.state.isLoading, isFalse);
        expect(model.state.errorMessage, AuthError.connection);

        await model.submit();
        expect(repository.requestedEmails, [
          'parent@example.com',
          'parent@example.com',
        ]);
        expect(model.state.isSent, isTrue);
        expect(model.state.errorMessage, isNull);
      },
    );

    test(
      'retries a resend without losing the sent acknowledgment state',
      () async {
        final repository = _AuthRepositoryFake();
        repository.requestHandler = (_) async {
          if (repository.requestedEmails.length == 2) {
            throw const AuthException(AuthError.connection);
          }
        };
        final model = _viewModel(repository);
        addTearDown(model.dispose);
        model.onEmailChange('parent@example.com');

        await model.submit();
        expect(model.state.isSent, isTrue);
        await model.submit();
        expect(model.state.isSent, isTrue);
        expect(model.state.email, 'parent@example.com');
        expect(model.state.errorMessage, AuthError.connection);

        await model.submit();
        expect(repository.requestedEmails.length, 3);
        expect(model.state.isSent, isTrue);
        expect(model.state.errorMessage, isNull);
      },
    );
  });
}

PasswordRecoveryViewModel _viewModel(_AuthRepositoryFake repository) =>
    PasswordRecoveryViewModel(
      requestPasswordRecovery: RequestPasswordRecoveryUseCase(
        repository: repository,
      ),
    );

class _AuthRepositoryFake implements AuthRepository {
  final List<String> requestedEmails = [];
  final List<String?> requestedLanguages = [];
  Future<void> Function(String email)? requestHandler;

  @override
  Future<void> requestPasswordRecovery(String email, {String? languageTag}) {
    requestedEmails.add(email);
    requestedLanguages.add(languageTag);
    return requestHandler?.call(email) ?? Future<void>.value();
  }

  @override
  Future<void> confirmPasswordRecovery(String token, String newPassword) async {
    throw UnimplementedError();
  }

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
