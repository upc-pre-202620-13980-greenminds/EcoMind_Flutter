import 'package:ecomind_parents/features/iam/application/sign_in_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_state.dart';
import 'package:flutter/material.dart';

class SignInViewModel extends ChangeNotifier {
  final SignInUseCase signIn;

  new({required this.signIn});

  SignInState _state = SignInState();
  SignInState get state => _state;

  void onEmailChange(String email) {
    _state = _state.copyWith(email: email, passwordError: _state.passwordError);
    notifyListeners();
  }

  void onPasswordChange(String password) {
    _state = _state.copyWith(password: password, emailError: _state.emailError);
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _state = _state.copyWith(
      isPasswordHidden: !_state.isPasswordHidden,
      emailError: _state.emailError,
      passwordError: _state.passwordError,
      errorMessage: _state.errorMessage,
    );
    notifyListeners();
  }

  Future<void> submit() async {
    // Ignores a second tap while the first request is running
    if (_state.isLoading || !_validate()) {
      return;
    }

    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      await signIn.execute(_state.email, _state.password);
      _state = _state.copyWith(isLoading: false, isAuthenticated: true);
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

  bool _validate() {
    final email = EmailAddress.normalize(_state.email);
    final FieldError? emailError = email.isEmpty
        ? FieldError.emailRequired
        : !EmailAddress.isValid(email)
        ? FieldError.emailInvalid
        : null;
    final FieldError? passwordError = _state.password.isEmpty
        ? FieldError.passwordRequired
        : null;

    _state = _state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
    );
    notifyListeners();
    return emailError == null && passwordError == null;
  }
}
