import 'package:ecomind_parents/features/iam/application/request_password_recovery_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_request/password_recovery_state.dart';
import 'package:flutter/material.dart';

class PasswordRecoveryViewModel extends ChangeNotifier {
  final RequestPasswordRecoveryUseCase requestPasswordRecovery;

  new({required this.requestPasswordRecovery});

  PasswordRecoveryState _state = PasswordRecoveryState();
  PasswordRecoveryState get state => _state;

  bool _isDisposed = false;

  void onEmailChange(String email) {
    _state = _state.copyWith(email: email);
    _notify();
  }

  // Sends the first request from the form, or the link again from the confirmation
  Future<void> submit({String? languageTag}) async {
    // Ignores a second tap while the first request is running
    if (_state.isLoading || !_validate()) {
      return;
    }
    final isResend = _state.isSent;

    _state = _state.copyWith(isLoading: true, isSent: isResend);
    _notify();

    try {
      await requestPasswordRecovery.execute(
        _state.email,
        languageTag: languageTag,
      );
      _state = _state.copyWith(
        isLoading: false,
        isSent: true,
        linkResent: isResend,
      );
    } on AuthException catch (e) {
      // The email stays in the field so the parent can try again
      _state = _state.copyWith(isLoading: false, errorMessage: e.error);
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: AuthError.unknown,
      );
    }
    _notify();
  }

  // Returns to the form with the same email, for example to correct it
  void editEmail() {
    if (_state.isLoading) {
      return;
    }
    _state = _state.copyWith(isSent: false);
    _notify();
  }

  bool _validate() {
    final email = EmailAddress.normalize(_state.email);
    final FieldError? emailError = email.isEmpty
        ? FieldError.emailRequired
        : !EmailAddress.isValid(email)
        ? FieldError.emailInvalid
        : null;

    if (emailError != null) {
      // An invalid email is corrected in the form
      _state = _state.copyWith(isSent: false, emailError: emailError);
      _notify();
    }
    return emailError == null;
  }

  // The page may close while a request is still running
  void _notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _state = PasswordRecoveryState();
    super.dispose();
  }
}
