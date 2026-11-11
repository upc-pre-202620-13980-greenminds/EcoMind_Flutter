import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/infrastructure/session_dao.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionDao dao;
  const new({required this.dao});

  @override
  Future<Session?> getSession() {
    return dao.getSession();
  }

  @override
  Future<void> saveSession(Session session) async {
    await dao.saveSession(session);
  }

  @override
  Future<void> clearSession() async {
    await dao.clearSession();
  }
}
