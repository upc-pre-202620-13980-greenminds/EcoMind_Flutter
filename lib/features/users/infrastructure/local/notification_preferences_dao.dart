import 'package:ecomind_parents/core/app_database.dart';
import 'package:ecomind_parents/features/users/domain/notification_preferences.dart';
import 'package:sqflite/sqflite.dart';

class NotificationPreferencesDao {
  final AppDatabase appDatabase;
  const new({required this.appDatabase});

  // One row per user: the id of the row is the account id
  Future<NotificationPreferences?> getPreferences(int accountId) async {
    Database database = await appDatabase.database;
    List<Map<String, Object?>> maps = await database.query(
      'notification_preferences',
      where: 'id = ?',
      whereArgs: [accountId],
    );
    if (maps.isEmpty) {
      return null;
    }
    final map = maps.first;
    // sqflite has no boolean type, so 1 is on and 0 is off
    return NotificationPreferences(
      newQuests: map['new_quests'] == 1,
      learningReminders: map['learning_reminders'] == 1,
      achievements: map['achievements'] == 1,
      weeklySummary: map['weekly_summary'] == 1,
      communityEvents: map['community_events'] == 1,
      communityActivity: map['community_activity'] == 1,
    );
  }

  Future<void> savePreferences(
    int accountId,
    NotificationPreferences preferences,
  ) async {
    Database database = await appDatabase.database;
    await database.insert('notification_preferences', {
      'id': accountId,
      'new_quests': preferences.newQuests ? 1 : 0,
      'learning_reminders': preferences.learningReminders ? 1 : 0,
      'achievements': preferences.achievements ? 1 : 0,
      'weekly_summary': preferences.weeklySummary ? 1 : 0,
      'community_events': preferences.communityEvents ? 1 : 0,
      'community_activity': preferences.communityActivity ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
