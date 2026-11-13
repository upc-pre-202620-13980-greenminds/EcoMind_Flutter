import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';

class ConfirmPasswordRecoveryUseCase {
  final AuthRepository authRepository;
  final SessionRepository sessionRepository;

  const new({required this.authRepository, required this.sessionRepository});

  Future<void> execute(
    String token,
    String newPassword, {
    String? confirmationId,
  }) async {
    try {
      await authRepository.confirmPasswordRecovery(
        token,
        newPassword,
        confirmationId: confirmationId,
      );
    } on AuthException catch (error) {
      if (error.error == AuthError.resetOutcomeUnknown) {
        // A changed password must not leave this device signed in to its old session.
        await sessionRepository.clearSession();
      }
      rethrow;
    }

    // The server does not revoke issued tokens, so this device signs out
    // and the parent signs in again with the new password
    await sessionRepository.clearSession();
  }
}
