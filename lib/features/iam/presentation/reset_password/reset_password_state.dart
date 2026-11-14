import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/presentation/auth_messages.dart';

enum ResetLinkStatus {
  // The link can be used to choose a new password
  usable,
  // The link is incomplete or malformed
  malformed,
  // The backend rejected the link: expired or already used
  rejected,
}

class ResetPasswordState {
  const new({
    this.linkStatus = ResetLinkStatus.usable,
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordHidden = true,
    this.isLoading = false,
    this.isCompleted = false,
    this.passwordError,
    this.confirmPasswordError,
    this.errorMessage,
  });

  final ResetLinkStatus linkStatus;
  final String password;
  final String confirmPassword;
  final bool isPasswordHidden;
  final bool isLoading;
  // The password was changed and the stored session was removed
  final bool isCompleted;
  final FieldError? passwordError;
  final FieldError? confirmPasswordError;
  // Error returned by the backend for the whole form
  final AuthError? errorMessage;

  bool get isLinkInvalid => linkStatus != ResetLinkStatus.usable;

  // The errors are not kept by copyWith: each change says which errors stay
  ResetPasswordState copyWith({
    ResetLinkStatus? linkStatus,
    String? password,
    String? confirmPassword,
    bool? isPasswordHidden,
    bool? isLoading,
    bool? isCompleted,
    FieldError? passwordError,
    FieldError? confirmPasswordError,
    AuthError? errorMessage,
  }) {
    return ResetPasswordState(
      linkStatus: linkStatus ?? this.linkStatus,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      errorMessage: errorMessage,
    );
  }

  // Never print the password, even in debug output
  @override
  String toString() =>
      'ResetPasswordState($linkStatus, loading: $isLoading, completed: $isCompleted)';
}
