import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/users/domain/notification_preferences.dart';
import 'package:ecomind_parents/features/users/domain/notification_preferences_repository.dart';
import 'package:ecomind_parents/features/users/infrastructure/local/notification_preferences_dao.dart';

class NotificationPreferencesRepositoryImpl
    implements NotificationPreferencesRepository {
  final NotificationPreferencesDao dao;
  // The preferences are kept per user, so two accounts on one phone do not mix them
  final SessionRepository sessionRepository;

  const new({required this.dao, required this.sessionRepository});

  @override
  Future<NotificationPreferences> getPreferences() async {
    final session = await sessionRepository.getSession();
    if (session == null) {
      return const NotificationPreferences();
    }
    // Nothing saved yet: every category is on
    return await dao.getPreferences(session.accountId) ??
        const NotificationPreferences();
  }

  @override
  Future<void> savePreferences(NotificationPreferences preferences) async {
    final session = await sessionRepository.getSession();
    if (session == null) {
      return;
    }
    await dao.savePreferences(session.accountId, preferences);
  }
}
