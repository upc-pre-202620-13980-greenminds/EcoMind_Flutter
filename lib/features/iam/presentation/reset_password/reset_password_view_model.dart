import 'package:ecomind_parents/features/iam/application/confirm_password_recovery_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_state.dart';
import 'package:flutter/material.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final ConfirmPasswordRecoveryUseCase confirmPasswordRecovery;

  new({required this.confirmPasswordRecovery});

  ResetPasswordState _state = ResetPasswordState();
  ResetPasswordState get state => _state;

  // Kept only in memory and only while it can still be used
  String? _token;
  bool _isDisposed = false;

  // Called once by the page with the token read from the link, or null
  void openLink(String? token) {
    _token = token;
    _state = ResetPasswordState(
      linkStatus: token == null
          ? ResetLinkStatus.malformed
          : ResetLinkStatus.usable,
    );
    _notify();
  }

  void onPasswordChange(String password) {
    _state = _state.copyWith(
      password: password,
      confirmPasswordError: _state.confirmPasswordError,
    );
    _notify();
  }

  void onConfirmPasswordChange(String confirmPassword) {
    _state = _state.copyWith(
      confirmPassword: confirmPassword,
      passwordError: _state.passwordError,
    );
    _notify();
  }

  void togglePasswordVisibility() {
    _state = _state.copyWith(
      isPasswordHidden: !_state.isPasswordHidden,
      passwordError: _state.passwordError,
      confirmPasswordError: _state.confirmPasswordError,
      errorMessage: _state.errorMessage,
    );
    _notify();
  }

  Future<void> submit() async {
    final token = _token;
    // Ignores a second tap while the first request is running
    if (_state.isLoading ||
        _state.isCompleted ||
        token == null ||
        !_validate()) {
      return;
    }

    _state = _state.copyWith(isLoading: true);
    _notify();

    try {
      await confirmPasswordRecovery.execute(token, _state.password);
      _forgetSecrets();
      _state = ResetPasswordState(isCompleted: true);
    } on AuthException catch (e) {
      if (e.error == AuthError.resetTokenInvalid) {
        // Expired or already used: only a new link can help
        _forgetSecrets();
        _state = ResetPasswordState(linkStatus: ResetLinkStatus.rejected);
      } else if (e.error == AuthError.passwordPolicy) {
        // The fields stay editable with what was typed
        _state = _state.copyWith(
          isLoading: false,
          passwordError: FieldError.passwordPolicy,
        );
      } else {
        // Connection and other errors keep the form so the parent can retry
        _state = _state.copyWith(isLoading: false, errorMessage: e.error);
      }
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: AuthError.unknown,
      );
    }
    if (_isDisposed) {
      // The page closed during the request: drop what the answer brought back
      _forgetSecrets();
      _state = ResetPasswordState();
      return;
    }
    _notify();
  }

  bool _validate() {
    final FieldError? passwordError =
        PasswordPolicy.isSatisfiedBy(_state.password)
        ? null
        : FieldError.passwordPolicy;
    final FieldError? confirmPasswordError =
        _state.confirmPassword == _state.password
        ? null
        : FieldError.passwordMismatch;

    _state = _state.copyWith(
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
    );
    _notify();
    return passwordError == null && confirmPasswordError == null;
  }

  void _forgetSecrets() {
    _token = null;
  }

  // The page may close while a request is still running
  void _notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // Clear transient form state when the page closes
  @override
  void dispose() {
    _isDisposed = true;
    _forgetSecrets();
    _state = ResetPasswordState();
    super.dispose();
  }
}
