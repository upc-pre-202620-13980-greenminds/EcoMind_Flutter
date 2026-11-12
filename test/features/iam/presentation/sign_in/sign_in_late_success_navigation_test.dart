import 'dart:async';

import 'package:ecomind_parents/features/iam/application/confirm_password_recovery_use_case.dart';
import 'package:ecomind_parents/features/iam/application/sign_in_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/iam/navigation/password_reset_link.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_page.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_page.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const token = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';

  testWidgets(
    'late sign-in success cannot replace a reset route opened during the request',
    (tester) async {
      final auth = _DelayedAuthRepository();
      final sessions = _TestSessionRepository();
      final signIn = SignInViewModel(
        signIn: SignInUseCase(
          authRepository: auth,
          sessionRepository: sessions,
        ),
      );
      final reset = ResetPasswordViewModel(
        confirmPasswordRecovery: ConfirmPasswordRecoveryUseCase(
          authRepository: auth,
          sessionRepository: sessions,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SignInPage(viewModel: signIn),
        ),
      );
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'parent@example.com');
      await tester.enterText(fields.at(1), 'synthetic-password');
      await tester.ensureVisible(find.text('Sign in'));
      await tester.tap(find.text('Sign in'));
      await tester.pump();
      expect(signIn.state.isLoading, isTrue);
      expect(auth.signInCalls, 1);

      final signInContext = tester.element(find.byType(SignInPage));
      Navigator.of(signInContext).push(
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: PasswordResetLink.routeName),
          builder: (_) => ResetPasswordPage(viewModel: reset, token: token),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ResetPasswordPage), findsOneWidget);

      auth.pendingSignIn.complete(
        Session(
          accessToken: 'synthetic-session-only',
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
          accountId: 42,
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(ResetPasswordPage), findsOneWidget);
      expect(find.byType(SignInPage), findsNothing);
      expect(find.text('Create a new password'), findsOneWidget);
      expect(
        ModalRoute.of(tester.element(find.byType(ResetPasswordPage)))
            ?.settings
            .name,
        PasswordResetLink.routeName,
      );
      expect(sessions.savedSessions, hasLength(1));
      expect(sessions.savedSessions.single.accountId, 42);
      expect(tester.takeException(), isNull);
    },
  );
}

class _DelayedAuthRepository implements AuthRepository {
  final Completer<Session> pendingSignIn = Completer<Session>();
  int signInCalls = 0;

  @override
  Future<Session> signIn(String email, String password) {
    signInCalls += 1;
    return pendingSignIn.future;
  }

  @override
  Future<SocialRole> getSocialRole(Session session) async => SocialRole.parent;

  @override
  Future<void> requestPasswordRecovery(
    String email, {
    String? languageTag,
  }) async {}

  @override
  Future<void> confirmPasswordRecovery(
    String token,
    String newPassword,
  ) async {}

  @override
  Future<void> signUp(
    String name,
    String email,
    String password,
    SocialRole role,
  ) async {}

  @override
  Future<void> verifyEmail(String email, String code) async {}

  @override
  Future<void> signOut(Session session) async {}
}

class _TestSessionRepository implements SessionRepository {
  final List<Session> savedSessions = [];

  @override
  Future<void> clearSession() async {}

  @override
  Future<Session?> getSession() async => null;

  @override
  Future<void> saveSession(Session session) async {
    savedSessions.add(session);
  }
}
