import 'package:ecomind_parents/features/iam/domain/session.dart';

abstract class SessionRepository {
  Future<Session?> getSession();
  Future<void> saveSession(Session session);
  Future<void> clearSession();
}
