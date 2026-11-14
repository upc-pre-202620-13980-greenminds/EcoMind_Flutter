import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/registration.dart';

class SignUpUseCase {
  final AuthRepository repository;

  const new({required this.repository});

  // Also used to resend the code: the backend replaces the pending registration
  Future<void> execute(Registration registration) async {
    await repository.signUp(
      registration.name.trim(),
      EmailAddress.normalize(registration.email),
      registration.password,
      // Students and parents can register in this application (HU-056)
      registration.role,
    );
  }
}
