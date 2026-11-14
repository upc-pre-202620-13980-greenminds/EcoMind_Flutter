import 'package:ecomind_parents/features/iam/application/sign_in_use_case.dart';
import 'package:ecomind_parents/features/iam/application/sign_up_use_case.dart';
import 'package:ecomind_parents/features/iam/application/verify_email_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/domain/registration.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';
import 'package:ecomind_parents/features/iam/presentation/verify_email/verify_email_state.dart';
import 'package:flutter/material.dart';

class VerifyEmailViewModel extends ChangeNotifier {
  final VerifyEmailUseCase verifyEmail;
  final SignUpUseCase signUp;
  final SignInUseCase signIn;

  new({required this.verifyEmail, required this.signUp, required this.signIn});

  VerifyEmailState _state = VerifyEmailState();
  VerifyEmailState get state => _state;

  void onCodeChange(String code) {
    _state = _state.copyWith(code: code, codeResent: false);
    notifyListeners();
  }

  Future<void> confirm(Registration registration) async {
    if (_state.isLoading) {
      return;
    }
    if (!VerificationCode.isValid(_state.code)) {
      _state = _state.copyWith(codeError: FieldError.codeFormat);
      notifyListeners();
      return;
    }

    _state = _state.copyWith(isLoading: true, codeResent: false);
    notifyListeners();

    try {
      await verifyEmail.execute(registration.email, _state.code);
    } on AuthException catch (e) {
      _state = _state.copyWith(isLoading: false, errorMessage: e.error);
      notifyListeners();
      return;
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: AuthError.unknown,
      );
      notifyListeners();
      return;
    }

    // The account exists now; it signs in with the same data, so the parent goes to Main
    try {
      await signIn.execute(registration.email, registration.password);
      _state = _state.copyWith(isLoading: false, isAuthenticated: true);
    } catch (e) {
      _state = _state.copyWith(isLoading: false, needsSignIn: true);
    }
    notifyListeners();
  }

  // Sending the registration again is how the backend sends a new code
  Future<void> resendCode(Registration registration) async {
    if (_state.isLoading) {
      return;
    }

    _state = _state.copyWith(isLoading: true, codeResent: false);
    notifyListeners();

    try {
      await signUp.execute(registration);
      _state = _state.copyWith(isLoading: false, codeResent: true);
    } on AuthException catch (e) {
      _state = _state.copyWith(isLoading: false, errorMessage: e.error);
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: AuthError.unknown,
      );
    }
    notifyListeners();
  }
}
