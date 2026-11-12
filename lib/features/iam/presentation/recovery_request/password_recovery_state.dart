import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';

class PasswordRecoveryState {
  const new({
    this.email = '',
    this.isLoading = false,
    this.isSent = false,
    this.linkResent = false,
    this.emailError,
    this.errorMessage,
  });

  final String email;
  final bool isLoading;
  // The request was accepted; the same message is shown for every email
  final bool isSent;
  // True right after the link is sent again from the confirmation view
  final bool linkResent;
  final FieldError? emailError;
  // Error returned by the backend for the whole form
  final AuthError? errorMessage;

  // The errors and linkResent are not kept by copyWith: each change says which stay
  PasswordRecoveryState copyWith({
    String? email,
    bool? isLoading,
    bool? isSent,
    bool? linkResent,
    FieldError? emailError,
    AuthError? errorMessage,
  }) {
    return PasswordRecoveryState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      isSent: isSent ?? this.isSent,
      linkResent: linkResent ?? false,
      emailError: emailError,
      errorMessage: errorMessage,
    );
  }
}
