import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/users/domain/commitment_repository.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:ecomind_parents/features/users/infrastructure/local/commitment_dao.dart';

class CommitmentRepositoryImpl implements CommitmentRepository {
  final CommitmentDao dao;
  // Kept per account, so two users on the same phone keep their own commitment
  final SessionRepository sessionRepository;

  const new({required this.dao, required this.sessionRepository});

  @override
  Future<String?> getCommitment() async {
    final session = await sessionRepository.getSession();
    if (session == null) {
      return null;
    }
    return dao.getCommitment(session.accountId);
  }

  @override
  Future<void> saveCommitment(String text) async {
    final session = await sessionRepository.getSession();
    if (session == null) {
      throw const UsersException(UsersError.sessionExpired);
    }
    await dao.saveCommitment(session.accountId, text);
  }
}
