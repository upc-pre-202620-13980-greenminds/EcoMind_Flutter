import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';

class SignInState {
  const new({
    this.email = '',
    this.password = '',
    this.isPasswordHidden = true,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.emailError,
    this.passwordError,
    this.errorMessage,
  });

  final String email;
  final String password;
  final bool isPasswordHidden;
  final bool isLoading;
  final bool isAuthenticated;
  final FieldError? emailError;
  final FieldError? passwordError;
  // Error returned by the backend for the whole form
  final AuthError? errorMessage;

  // The errors are not kept by copyWith: each change says which errors stay
  SignInState copyWith({
    String? email,
    String? password,
    bool? isPasswordHidden,
    bool? isLoading,
    bool? isAuthenticated,
    FieldError? emailError,
    FieldError? passwordError,
    AuthError? errorMessage,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      emailError: emailError,
      passwordError: passwordError,
      errorMessage: errorMessage,
    );
  }
}
