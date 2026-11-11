import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';

class SignInUseCase {
  final AuthRepository authRepository;
  final SessionRepository sessionRepository;

  const new({required this.authRepository, required this.sessionRepository});

  Future<void> execute(String email, String password) async {
    final session = await authRepository.signIn(
      EmailAddress.normalize(email),
      password,
    );

    // The sign in response has no role, so it is read from the profile in Users
    final role = await authRepository.getSocialRole(session);
    if (role != SocialRole.parent) {
      // The token is discarded: a student account cannot enter this application
      throw const AuthException(AuthError.notParent);
    }

    await sessionRepository.saveSession(session);
  }
}
