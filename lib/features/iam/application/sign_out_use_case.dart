import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';

class SignOutUseCase {
  final AuthRepository authRepository;
  final SessionRepository sessionRepository;

  const new({required this.authRepository, required this.sessionRepository});

  Future<void> execute() async {
    final session = await sessionRepository.getSession();
    if (session != null) {
      try {
        await authRepository.signOut(session);
      } catch (e) {
        // Without network or with an expired token the session must still end here
      }
    }
    await sessionRepository.clearSession();
  }
}
