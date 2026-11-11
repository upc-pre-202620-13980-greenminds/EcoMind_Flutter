import 'package:ecomind_parents/core/app_database.dart';
import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:sqflite/sqflite.dart';

class SessionDao {
  final AppDatabase appDatabase;
  const new({required this.appDatabase});

  // The table only keeps one row: the session of the signed in parent
  static const int _sessionId = 1;

  Future<Session?> getSession() async {
    Database database = await appDatabase.database;
    List<Map<String, Object?>> maps = await database.query(
      'session',
      where: 'id = ?',
      whereArgs: [_sessionId],
    );
    if (maps.isEmpty) {
      return null;
    }
    final map = maps.first;
    return Session(
      accessToken: map['access_token'] as String,
      expiresAt: DateTime.parse(map['expires_at'] as String),
      accountId: map['account_id'] as int,
    );
  }

  Future<void> saveSession(Session session) async {
    Database database = await appDatabase.database;
    await database.insert('session', {
      'id': _sessionId,
      'access_token': session.accessToken,
      'expires_at': session.expiresAt.toUtc().toIso8601String(),
      'account_id': session.accountId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clearSession() async {
    Database database = await appDatabase.database;
    await database.delete('session');
  }
}
