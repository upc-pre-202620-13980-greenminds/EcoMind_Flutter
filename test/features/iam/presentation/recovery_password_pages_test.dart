import 'package:ecomind_parents/features/iam/application/request_password_recovery_use_case.dart';
import 'package:ecomind_parents/features/iam/application/confirm_password_recovery_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_request/password_recovery_page.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_request/password_recovery_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_page.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const es419 = Locale('es', '419');
  const token = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';

  testWidgets(
    'recovery form fits 360x800 at 150% Spanish text and can submit',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repository = _TestAuthRepository();
      final viewModel = PasswordRecoveryViewModel(
        requestPasswordRecovery: RequestPasswordRecoveryUseCase(
          repository: repository,
        ),
      );
      await tester.pumpWidget(
        _localizedApp(
          locale: es419,
          textScale: 1.5,
          child: PasswordRecoveryPage(viewModel: viewModel),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Restablece tu contraseña'), findsOneWidget);
      expect(find.text('Correo electrónico'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.enterText(find.byType(TextFormField), 'Parent@Example.com');
      await tester.ensureVisible(find.text('Enviar enlace'));
      await tester.tap(find.text('Enviar enlace'));
      await tester.pumpAndSettle();

      expect(repository.requestedEmails, ['parent@example.com']);
      expect(find.text('Revisa tu correo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'reset form is scrollable and password visibility works in Spanish',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repository = _TestAuthRepository();
      final sessions = _TestSessionRepository();
      final viewModel = ResetPasswordViewModel(
        confirmPasswordRecovery: ConfirmPasswordRecoveryUseCase(
          authRepository: repository,
          sessionRepository: sessions,
        ),
      );
      await tester.pumpWidget(
        _localizedApp(
          locale: es419,
          textScale: 1.5,
          child: ResetPasswordPage(viewModel: viewModel, token: token),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Crea una contraseña nueva'), findsOneWidget);
      expect(find.text('Contraseña nueva'), findsOneWidget);
      expect(find.text('Confirmar contraseña nueva'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).first)
            .obscureText,
        isTrue,
      );
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Guardar contraseña nueva'));
      await tester.tap(find.byTooltip('Mostrar contraseña'));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<EditableText>(find.byType(EditableText).first)
            .obscureText,
        isFalse,
      );
      expect(find.byTooltip('Ocultar contraseña'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('reset screen renders in English at the standard text scale', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _TestAuthRepository();
    final sessions = _TestSessionRepository();
    final viewModel = ResetPasswordViewModel(
      confirmPasswordRecovery: ConfirmPasswordRecoveryUseCase(
        authRepository: repository,
        sessionRepository: sessions,
      ),
    );
    await tester.pumpWidget(
      _localizedApp(
        locale: const Locale('en'),
        textScale: 1,
        child: ResetPasswordPage(viewModel: viewModel, token: token),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create a new password'), findsOneWidget);
    expect(find.text('New password'), findsOneWidget);
    expect(find.text('Confirm new password'), findsOneWidget);
  });
}

Widget _localizedApp({
  required Locale locale,
  required double textScale,
  required Widget child,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) {
      final mediaQuery = MediaQuery.of(context);
      return MediaQuery(
        data: mediaQuery.copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      );
    },
    home: child,
  );
}

class _TestAuthRepository implements AuthRepository {
  final List<String> requestedEmails = [];
  final List<(String, String)> confirmed = [];

  @override
  Future<void> requestPasswordRecovery(
    String email, {
    String? languageTag,
  }) async {
    requestedEmails.add(email);
  }

  @override
  Future<void> confirmPasswordRecovery(String token, String newPassword) async {
    confirmed.add((token, newPassword));
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

class _TestSessionRepository implements SessionRepository {
  @override
  Future<void> clearSession() async {}

  @override
  Future<Session?> getSession() async => null;

  @override
  Future<void> saveSession(Session session) async {}
}
