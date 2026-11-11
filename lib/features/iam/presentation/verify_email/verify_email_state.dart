import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';

class VerifyEmailState {
  const new({
    this.code = '',
    this.isLoading = false,
    this.codeResent = false,
    this.isAuthenticated = false,
    this.needsSignIn = false,
    this.codeError,
    this.errorMessage,
  });

  final String code;
  final bool isLoading;
  // True after a new code was requested, until the code is typed again
  final bool codeResent;
  final bool isAuthenticated;
  // The account was created but the automatic sign in failed
  final bool needsSignIn;
  final FieldError? codeError;
  final AuthError? errorMessage;

  // The errors are not kept by copyWith: each change says which errors stay
  VerifyEmailState copyWith({
    String? code,
    bool? isLoading,
    bool? codeResent,
    bool? isAuthenticated,
    bool? needsSignIn,
    FieldError? codeError,
    AuthError? errorMessage,
  }) {
    return VerifyEmailState(
      code: code ?? this.code,
      isLoading: isLoading ?? this.isLoading,
      codeResent: codeResent ?? this.codeResent,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      needsSignIn: needsSignIn ?? this.needsSignIn,
      codeError: codeError,
      errorMessage: errorMessage,
    );
  }
}
