import 'package:ecomind_parents/features/iam/domain/session_repository.dart';

class CheckSessionUseCase {
  final SessionRepository repository;

  const new({required this.repository});

  // True only when there is a stored session whose token is still valid
  Future<bool> execute() async {
    final session = await repository.getSession();
    if (session == null) {
      return false;
    }
    if (session.isExpired(DateTime.now())) {
      await repository.clearSession();
      return false;
    }
    return true;
  }
}
