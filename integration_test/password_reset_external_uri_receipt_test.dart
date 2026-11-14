import 'dart:convert';
import 'dart:io';

import 'package:ecomind_parents/core/widgets/form_error_text.dart';
import 'package:ecomind_parents/core/widgets/primary_button.dart';
import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_page.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_request/password_recovery_page.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_page.dart';
import 'package:ecomind_parents/features/main/main_page.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ecomind_parents/main.dart' as app;

Future<void> _pumpUntil(
  WidgetTester tester,
  bool Function() condition,
  String failureMessage, {
  Duration timeout = const Duration(minutes: 2),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline) && !condition()) {
    await tester.pump(const Duration(milliseconds: 250));
  }
  expect(condition(), isTrue, reason: failureMessage);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const liveMode = bool.fromEnvironment('IAM_LIVE', defaultValue: false);
  const controlledLinkMode = bool.fromEnvironment(
    'IAM_CONTROLLED_LINK',
    defaultValue: false,
  );

  testWidgets(
    'handles native ACTION_VIEW and completes the selected recovery flow',
    (tester) async {
      if (liveMode && controlledLinkMode) {
        throw TestFailure('Choose only one IAM recovery test mode.');
      }

      app.main();
      await tester.pump();

      // The staged fixture is private. Controlled mode exercises an existing
      // test link and skips the recovery-email request entirely.
      const fixturePath =
          '/storage/emulated/0/Android/data/pe.greenminds.ecomind_parents/files/flutter-live-fixture.json';
      final fixtureFile = File(fixturePath);
      String? email;
      String? newPassword;
      if (liveMode || controlledLinkMode) {
        if (!await fixtureFile.exists()) {
          throw TestFailure('Selected IAM mode requires the private fixture.');
        }
        final Object? decoded;
        try {
          decoded = jsonDecode(await fixtureFile.readAsString());
        } on FormatException {
          throw TestFailure('Live fixture is malformed.');
        }
        if (decoded is! Map<String, dynamic> ||
            decoded['email'] is! String ||
            decoded['newPassword'] is! String) {
          throw TestFailure('Live fixture is missing required fields.');
        }
        email = decoded['email'] as String;
        newPassword = decoded['newPassword'] as String;
        if (email.trim().isEmpty || newPassword.trim().isEmpty) {
          throw TestFailure('Live fixture contains an empty value.');
        }
      }

      if (liveMode) {
        // Submit only when the explicit private fixture has been staged.
        final requestDeadline = DateTime.now().add(const Duration(minutes: 2));
        while (DateTime.now().isBefore(requestDeadline) &&
            find.text('Forgot your password?').evaluate().isEmpty) {
          await tester.pump(const Duration(milliseconds: 250));
        }
        expect(find.text('Forgot your password?'), findsOneWidget);
        await tester.tap(find.text('Forgot your password?'));
        await tester.pumpAndSettle();
        expect(find.byType(PasswordRecoveryPage), findsOneWidget);
        await tester.enterText(find.byType(TextFormField), email!);
        await tester.ensureVisible(find.byType(PrimaryButton));
        await tester.tap(find.byType(PrimaryButton));
        await _pumpUntil(
          tester,
          () =>
              find.text('Check your email').evaluate().isNotEmpty ||
              find.byType(FormErrorText).evaluate().isNotEmpty,
          'Recovery request did not finish before the timeout.',
        );
        expect(find.byType(FormErrorText), findsNothing);
        expect(find.text('Check your email'), findsOneWidget);
      }

      // The Android instrumentation helper sends the URI from a private fixture
      // while this app process is running. Do not log or capture the URI/token.
      final deadline = DateTime.now().add(const Duration(minutes: 5));
      while (DateTime.now().isBefore(deadline) &&
          find.text('Create a new password').evaluate().isEmpty) {
        await tester.pump(const Duration(milliseconds: 250));
      }

      expect(find.byType(ResetPasswordPage), findsOneWidget);
      expect(find.text('Create a new password'), findsOneWidget);
      final resetPage = tester.widget<ResetPasswordPage>(
        find.byType(ResetPasswordPage),
      );
      final visibleText = tester
          .widgetList<Text>(find.byType(Text))
          .map((text) => text.data ?? text.textSpan?.toPlainText() ?? '')
          .join('\n');
      if (resetPage.token case final token?) {
        expect(visibleText.contains(token), isFalse);
      }

      if (newPassword != null && email != null) {
        final passwordFields = find.byType(TextFormField);
        expect(passwordFields, findsNWidgets(2));
        await tester.enterText(passwordFields.at(0), newPassword);
        await tester.enterText(passwordFields.at(1), newPassword);
        await tester.ensureVisible(find.byType(PrimaryButton));
        await tester.tap(find.byType(PrimaryButton));

        final resetDeadline = DateTime.now().add(const Duration(minutes: 2));
        while (DateTime.now().isBefore(resetDeadline) &&
            find.text('Password updated').evaluate().isEmpty &&
            find.byType(FormErrorText).evaluate().isEmpty) {
          await tester.pump(const Duration(milliseconds: 250));
        }
        expect(find.byType(FormErrorText), findsNothing);
        expect(find.text('Password updated'), findsOneWidget);
        await tester.pump(const Duration(seconds: 2));

        // Log in with the new credential through the normal sign-in form.
        await tester.tap(find.byType(PrimaryButton));
        await tester.pumpAndSettle();
        expect(find.byType(SignInPage), findsOneWidget);
        final signInFields = find.byType(TextFormField);
        expect(signInFields, findsNWidgets(2));
        await tester.enterText(signInFields.at(0), email);
        await tester.enterText(signInFields.at(1), newPassword);
        await tester.ensureVisible(find.byType(PrimaryButton));
        await tester.tap(find.byType(PrimaryButton));

        final loginDeadline = DateTime.now().add(const Duration(minutes: 2));
        while (DateTime.now().isBefore(loginDeadline) &&
            find.byType(MainPage).evaluate().isEmpty) {
          await tester.pump(const Duration(milliseconds: 250));
        }
        expect(find.byType(MainPage), findsOneWidget);
        expect(find.byType(ProfilePage), findsOneWidget);
        expect(await getIt<SessionRepository>().getSession(), isNotNull);
        await tester.pump(const Duration(seconds: 2));

        await tester.tap(find.byTooltip('Profile'));
        await tester.pump();
        final profileDeadline = DateTime.now().add(const Duration(minutes: 2));
        while (DateTime.now().isBefore(profileDeadline) &&
            find.text('Sign out').evaluate().isEmpty) {
          await tester.pump(const Duration(milliseconds: 250));
        }
        expect(find.byType(ProfilePage), findsOneWidget);
        expect(find.text('Sign out'), findsOneWidget);
        await tester.ensureVisible(find.text('Sign out'));
        await tester.tap(find.text('Sign out'));

        final signOutDeadline = DateTime.now().add(const Duration(minutes: 2));
        while (DateTime.now().isBefore(signOutDeadline) &&
            find.byType(SignInPage).evaluate().isEmpty) {
          await tester.pump(const Duration(milliseconds: 250));
        }
        expect(find.byType(SignInPage), findsOneWidget);
        expect(find.byType(MainPage), findsNothing);
        expect(await getIt<SessionRepository>().getSession(), isNull);
        final loggedOutFields = tester
            .widgetList<EditableText>(find.byType(EditableText))
            .toList();
        expect(loggedOutFields, hasLength(2));
        expect(loggedOutFields[0].controller.text, isEmpty);
        expect(loggedOutFields[1].controller.text, isEmpty);
        await tester.pump(const Duration(seconds: 2));

        await tester.binding.handlePopRoute();
        await tester.pump();
        expect(find.byType(SignInPage), findsOneWidget);
        expect(find.byType(MainPage), findsNothing);
      }
    },
    skip: !liveMode && !controlledLinkMode,
    timeout: const Timeout(Duration(minutes: 12)),
  );
}
