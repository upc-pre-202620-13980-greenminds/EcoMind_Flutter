import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/registration.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';

class SignUpUseCase {
  final AuthRepository repository;

  const new({required this.repository});

  // Also used to resend the code: the backend replaces the pending registration
  Future<void> execute(Registration registration) async {
    await repository.signUp(
      registration.name.trim(),
      EmailAddress.normalize(registration.email),
      registration.password,
      // This application only registers parents
      SocialRole.parent,
    );
  }
}
