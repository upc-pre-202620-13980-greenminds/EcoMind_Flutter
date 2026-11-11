import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository repository;

  const new({required this.repository});

  Future<void> execute(String email, String code) async {
    await repository.verifyEmail(EmailAddress.normalize(email), code);
  }
}
