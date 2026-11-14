import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  Future<Database>? _database;

  Future<Database> get database => _database ??= _openDatabase();

  Future<Database> _openDatabase() async {
    final path = join(await getDatabasesPath(), 'ecomind_parents.db');

    return openDatabase(
      path,
      // Version 2: quests and learning preferences of the students and the personal commitment
      version: 2,
      onCreate: (db, version) async {
        // A single row with the session of the signed in user
        await db.execute(
          'create table session ('
          'id integer primary key, '
          'access_token text not null, '
          'expires_at text not null, '
          'account_id integer not null)',
        );
        // The backend does not store these preferences, so they live on the device
        await db.execute(
          'create table notification_preferences ('
          'id integer primary key, '
          'achievements integer not null, '
          'weekly_summary integer not null, '
          'community_events integer not null, '
          'community_activity integer not null, '
          'new_quests integer not null default 1, '
          'learning_reminders integer not null default 1)',
        );
        await _createCommitmentTable(db);
      },
      // A phone that already had version 1 keeps its session and preferences
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'alter table notification_preferences '
            'add column new_quests integer not null default 1',
          );
          await db.execute(
            'alter table notification_preferences '
            'add column learning_reminders integer not null default 1',
          );
          await _createCommitmentTable(db);
        }
      },
    );
  }

  // The backend has no route for the personal commitment (HU-006), so it stays on the device.
  // One row per user: the id of the row is the account id.
  Future<void> _createCommitmentTable(Database db) async {
    await db.execute(
      'create table personal_commitment ('
      'id integer primary key, '
      'text text not null)',
    );
  }
}
