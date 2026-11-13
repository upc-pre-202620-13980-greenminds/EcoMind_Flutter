import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';

class SignInUseCase {
  final AuthRepository authRepository;
  final SessionRepository sessionRepository;

  const new({required this.authRepository, required this.sessionRepository});

  // Students and parents can enter: the role only decides what each one sees
  Future<void> execute(String email, String password) async {
    final session = await authRepository.signIn(
      EmailAddress.normalize(email),
      password,
    );
    await sessionRepository.saveSession(session);
  }
}
