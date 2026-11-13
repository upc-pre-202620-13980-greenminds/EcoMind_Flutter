import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/form_error_text.dart';
import 'package:ecomind_parents/core/widgets/primary_button.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/infrastructure/remote/iam_api.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_page.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_page.dart';
import 'package:ecomind_parents/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const enabled = bool.fromEnvironment(
    'IAM_LOST_RESPONSE',
    defaultValue: false,
  );
  testWidgets(
    'recovers a real committed reset when its first response is lost',
    (tester) async {
      // The integration runner already owns the binding. Register only its test keyboard.
      tester.testTextInput.register();
      addTearDown(tester.testTextInput.unregister);
      // Opt-in: this changes only the account supplied by the private fixture.
      const directory = '/data/user/0/pe.greenminds.ecomind_parents/files';
      await Directory(directory).create(recursive: true);
      final file = File('$directory/flutter-live-fixture.json');
      final ready = File('$directory/recovery-test-ready');
      await ready.writeAsString('ready');
      final deadline = DateTime.now().add(const Duration(seconds: 90));
      while (!await file.exists() && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
      if (!await file.exists()) {
        throw TestFailure('Private fixture was not staged.');
      }
      final fixture =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      await file.delete();
      await ready.delete();
      final email = fixture['email'] as String;
      final password = fixture['newPassword'] as String;
      final link = Uri.parse(fixture['recoveryLink'] as String);
      final fault = _ResponseLoss();
      final api = IamApi(clientFactory: () => _DropFirstResponseClient(fault));
      setupDependencies();
      await getIt.unregister<IamApi>();
      getIt.registerLazySingleton<IamApi>(() => api);
      await getIt<SessionRepository>().clearSession();
      final links = StreamController<Uri>();
      addTearDown(links.close);
      runApp(MainApp(links: links.stream));
      await _until(tester, () => find.byType(SignInPage).evaluate().isNotEmpty);
      links.add(link);
      await _until(
        tester,
        () => find.byType(ResetPasswordPage).evaluate().isNotEmpty,
      );
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), password);
      await tester.pump();
      await tester.enterText(fields.at(1), password);
      await tester.pump();
      final page = tester.widget<ResetPasswordPage>(
        find.byType(ResetPasswordPage),
      );
      expect(
        page.viewModel.state.password == password,
        isTrue,
        reason: 'Password input did not reach the form.',
      );
      expect(
        page.viewModel.state.confirmPassword == password,
        isTrue,
        reason: 'Confirmation input did not reach the form.',
      );
      await tester.ensureVisible(find.byType(PrimaryButton));
      await tester.tap(find.byType(PrimaryButton));
      await _until(
        tester,
        () =>
            find.text('Password updated').evaluate().isNotEmpty ||
            find.byType(FormErrorText).evaluate().isNotEmpty,
      );
      expect(find.byType(FormErrorText), findsNothing);
      expect(find.text('Password updated'), findsOneWidget);
      expect(fault.dropped, isTrue);
      expect(fault.attempts, 2);
      expect(fault.payloads.toSet().length, 1);
      expect(await getIt<SessionRepository>().getSession(), isNull);
      // Do not include authentication responses, request bodies or the link in output.
      final session = await api.signIn(email, password);
      await api.logout(session.accessToken);
      await tester.pump(const Duration(seconds: 2));
    },
    skip: !enabled,
    timeout: const Timeout(Duration(minutes: 5)),
  );
}

Future<void> _until(WidgetTester tester, bool Function() condition) async {
  final deadline = DateTime.now().add(const Duration(minutes: 2));
  while (!condition() && DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 250));
  }
  expect(condition(), isTrue, reason: 'Recovery stage did not finish.');
}

class _ResponseLoss {
  bool dropped = false;
  int attempts = 0;
  final List<String> payloads = [];
}

class _DropFirstResponseClient extends http.BaseClient {
  final _ResponseLoss fault;
  final http.Client _inner = http.Client();
  _DropFirstResponseClient(this.fault);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    fault.attempts++;
    if (request is http.Request) fault.payloads.add(request.body);
    final response = await _inner.send(request);
    if (!fault.dropped && response.statusCode == HttpStatus.noContent) {
      await response.stream.drain<void>();
      fault.dropped = true;
      throw const SocketException('Simulated loss after server confirmation');
    }
    return response;
  }

  @override
  void close() => _inner.close();
}
