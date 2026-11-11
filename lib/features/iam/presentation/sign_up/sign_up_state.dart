import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';

class SignUpState {
  const new({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.termsAccepted = false,
    this.isLoading = false,
    this.isCodeSent = false,
    this.nameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.termsError,
    this.errorMessage,
  });

  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool termsAccepted;
  final bool isLoading;
  // True when the backend accepted the registration and sent the code
  final bool isCodeSent;
  final FieldError? nameError;
  final FieldError? emailError;
  final FieldError? passwordError;
  final FieldError? confirmPasswordError;
  final FieldError? termsError;
  final AuthError? errorMessage;

  // The errors are not kept by copyWith: each change says which errors stay
  SignUpState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? termsAccepted,
    bool? isLoading,
    bool? isCodeSent,
    FieldError? nameError,
    FieldError? emailError,
    FieldError? passwordError,
    FieldError? confirmPasswordError,
    FieldError? termsError,
    AuthError? errorMessage,
  }) {
    return SignUpState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isLoading: isLoading ?? this.isLoading,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      nameError: nameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      termsError: termsError,
      errorMessage: errorMessage,
    );
  }
}
