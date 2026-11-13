import 'dart:async';

import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/features/iam/application/check_session_use_case.dart';
import 'package:ecomind_parents/features/iam/application/confirm_password_recovery_use_case.dart';
import 'package:ecomind_parents/features/iam/application/request_password_recovery_use_case.dart';
import 'package:ecomind_parents/features/iam/application/sign_in_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/iam/navigation/password_reset_link.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_request/password_recovery_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_page.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_page.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/splash/splash_view_model.dart';
import 'package:ecomind_parents/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const token = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
  final resetUri = Uri.parse(
    'ecomind://authentication/reset-password?token=$token',
  );

  setUp(() async {
    await getIt.reset();
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets(
    'cold reset link survives splash session check and clears old route',
    (tester) async {
      final pendingSession = Completer<Session?>();
      final services = _registerTestServices(
        sessions: _TestSessionRepository(pendingSession: pendingSession),
      );
      final links = StreamController<Uri>();
      // Queue the platform's initial URI before MainApp subscribes.
      links.add(resetUri);
      addTearDown(links.close);

      await tester.pumpWidget(MainApp(links: links.stream));
      await tester.pumpAndSettle();
      expect(find.byType(ResetPasswordPage), findsOneWidget);
      expect(_currentRouteName(tester), PasswordResetLink.routeName);
      expect(services.resetViewModelsCreated, 1);

      // A slow stored-session read completes after the reset route is already on top.
      pendingSession.complete(null);
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(ResetPasswordPage), findsOneWidget);
      expect(find.byType(SignInPage), findsNothing);
      expect(_currentRouteName(tester), PasswordResetLink.routeName);
      expect(services.resetViewModelsCreated, 1);
      expect(find.textContaining(token), findsNothing);
    },
  );

  testWidgets(
    'warm links ignore unrelated URIs, deduplicate startup, reopen later, and back to sign in',
    (tester) async {
      final services = _registerTestServices(
        sessions: _TestSessionRepository(),
      );
      final links = StreamController<Uri>.broadcast();
      addTearDown(links.close);

      await tester.pumpWidget(MainApp(links: links.stream));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.byType(SignInPage), findsOneWidget);

      links.add(
        Uri.parse('https://example.invalid/reset-password?token=$token'),
      );
      await tester.pump();
      expect(find.byType(ResetPasswordPage), findsNothing);

      links.add(resetUri);
      await tester.pumpAndSettle();
      expect(find.byType(ResetPasswordPage), findsOneWidget);
      expect(services.resetViewModelsCreated, 1);
      expect(_currentRouteName(tester), PasswordResetLink.routeName);

      // The same initial URI delivered again immediately is a platform duplicate.
      links.add(resetUri);
      await tester.pumpAndSettle();
      expect(services.resetViewModelsCreated, 1);

      // Opening the same, now-older link later must still reach the page.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(seconds: 3)),
      );
      links.add(resetUri);
      await tester.pumpAndSettle();
      expect(services.resetViewModelsCreated, 2);
      expect(_currentRouteName(tester), PasswordResetLink.routeName);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(SignInPage), findsOneWidget);
      expect(find.byType(ResetPasswordPage), findsNothing);
      expect(_currentRouteName(tester), isNot(PasswordResetLink.routeName));
    },
  );
}

String? _currentRouteName(WidgetTester tester) {
  final resetPage = find.byType(ResetPasswordPage);
  if (resetPage.evaluate().isEmpty) {
    final signInPage = find.byType(SignInPage);
    if (signInPage.evaluate().isEmpty) return null;
    return ModalRoute.of(tester.element(signInPage))?.settings.name;
  }
  return ModalRoute.of(tester.element(resetPage))?.settings.name;
}

_TestServices _registerTestServices({
  required _TestSessionRepository sessions,
}) {
  final auth = _TestAuthRepository();
  final checkSession = CheckSessionUseCase(repository: sessions);
  final signIn = SignInUseCase(
    authRepository: auth,
    sessionRepository: sessions,
  );
  final requestRecovery = RequestPasswordRecoveryUseCase(repository: auth);
  final confirmRecovery = ConfirmPasswordRecoveryUseCase(
    authRepository: auth,
    sessionRepository: sessions,
  );
  var resetViewModelsCreated = 0;

  getIt.registerFactory<SplashViewModel>(
    () => SplashViewModel(checkSession: checkSession),
  );
  getIt.registerFactory<SignInViewModel>(() => SignInViewModel(signIn: signIn));
  getIt.registerFactory<PasswordRecoveryViewModel>(
    () => PasswordRecoveryViewModel(requestPasswordRecovery: requestRecovery),
  );
  getIt.registerFactory<ResetPasswordViewModel>(() {
    resetViewModelsCreated += 1;
    return ResetPasswordViewModel(confirmPasswordRecovery: confirmRecovery);
  });

  return _TestServices(() => resetViewModelsCreated);
}

class _TestServices {
  final int Function() _readResetViewModelCount;

  const _TestServices(this._readResetViewModelCount);

  int get resetViewModelsCreated => _readResetViewModelCount();
}

class _TestAuthRepository implements AuthRepository {
  @override
  Future<void> requestPasswordRecovery(
    String email, {
    String? languageTag,
  }) async {}

  @override
  Future<void> confirmPasswordRecovery(
    String token,
    String newPassword, {
    String? confirmationId,
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

class _TestSessionRepository implements SessionRepository {
  final Completer<Session?>? pendingSession;

  const _TestSessionRepository({this.pendingSession});

  @override
  Future<void> clearSession() async {}

  @override
  Future<Session?> getSession() => pendingSession?.future ?? Future.value(null);

  @override
  Future<void> saveSession(Session session) async {}
}
