import 'package:ecomind_parents/features/iam/application/sign_up_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/domain/registration.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_up/sign_up_state.dart';
import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  final SignUpUseCase signUp;

  new({required this.signUp});

  SignUpState _state = SignUpState();
  SignUpState get state => _state;

  Registration get registration => Registration(
    name: _state.name,
    email: _state.email,
    password: _state.password,
  );

  // Each change clears the error of its own field and keeps the others
  void onNameChange(String name) {
    _state = _state.copyWith(
      name: name,
      emailError: _state.emailError,
      passwordError: _state.passwordError,
      confirmPasswordError: _state.confirmPasswordError,
      termsError: _state.termsError,
    );
    notifyListeners();
  }

  void onEmailChange(String email) {
    _state = _state.copyWith(
      email: email,
      nameError: _state.nameError,
      passwordError: _state.passwordError,
      confirmPasswordError: _state.confirmPasswordError,
      termsError: _state.termsError,
    );
    notifyListeners();
  }

  void onPasswordChange(String password) {
    _state = _state.copyWith(
      password: password,
      nameError: _state.nameError,
      emailError: _state.emailError,
      confirmPasswordError: _state.confirmPasswordError,
      termsError: _state.termsError,
    );
    notifyListeners();
  }

  void onConfirmPasswordChange(String confirmPassword) {
    _state = _state.copyWith(
      confirmPassword: confirmPassword,
      nameError: _state.nameError,
      emailError: _state.emailError,
      passwordError: _state.passwordError,
      termsError: _state.termsError,
    );
    notifyListeners();
  }

  void onTermsAcceptedChange(bool accepted) {
    _state = _state.copyWith(
      termsAccepted: accepted,
      nameError: _state.nameError,
      emailError: _state.emailError,
      passwordError: _state.passwordError,
      confirmPasswordError: _state.confirmPasswordError,
    );
    notifyListeners();
  }

  // Called by the page after it opens Verify email, so it is not opened twice
  void onCodeScreenOpened() {
    _state = _state.copyWith(isCodeSent: false);
  }

  Future<void> submit() async {
    if (_state.isLoading || !_validate()) {
      return;
    }

    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      await signUp.execute(registration);
      _state = _state.copyWith(isLoading: false, isCodeSent: true);
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
    final FieldError? nameError = PersonName.isValid(_state.name)
        ? null
        : FieldError.nameInvalid;
    final FieldError? emailError = email.isEmpty
        ? FieldError.emailRequired
        : !EmailAddress.isValid(email)
        ? FieldError.emailInvalid
        : null;
    final FieldError? passwordError =
        PasswordPolicy.isSatisfiedBy(_state.password)
        ? null
        : FieldError.passwordPolicy;
    final FieldError? confirmPasswordError =
        _state.confirmPassword == _state.password
        ? null
        : FieldError.passwordMismatch;
    final FieldError? termsError = _state.termsAccepted
        ? null
        : FieldError.termsRequired;

    _state = _state.copyWith(
      nameError: nameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      termsError: termsError,
    );
    notifyListeners();
    return [
      nameError,
      emailError,
      passwordError,
      confirmPasswordError,
      termsError,
    ].every((error) => error == null);
  }
}
