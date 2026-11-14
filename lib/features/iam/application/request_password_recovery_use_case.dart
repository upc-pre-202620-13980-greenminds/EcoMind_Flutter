import 'package:ecomind_parents/features/iam/domain/account_rules.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';

class RequestPasswordRecoveryUseCase {
  final AuthRepository repository;

  const new({required this.repository});

  // Also used to resend the link: the backend issues a new one for each request
  Future<void> execute(String email, {String? languageTag}) async {
    await repository.requestPasswordRecovery(
      EmailAddress.normalize(email),
      languageTag: languageTag,
    );
  }
}
