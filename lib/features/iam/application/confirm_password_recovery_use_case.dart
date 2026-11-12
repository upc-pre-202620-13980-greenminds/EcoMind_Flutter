import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';

class ConfirmPasswordRecoveryUseCase {
  final AuthRepository authRepository;
  final SessionRepository sessionRepository;

  const new({required this.authRepository, required this.sessionRepository});

  Future<void> execute(String token, String newPassword) async {
    // Throws an AuthException and keeps the session when the reset fails
    await authRepository.confirmPasswordRecovery(token, newPassword);

    // The server does not revoke issued tokens, so this device signs out
    // and the parent signs in again with the new password
    await sessionRepository.clearSession();
  }
}
