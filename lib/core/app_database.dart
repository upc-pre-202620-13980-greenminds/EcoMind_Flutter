import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  Future<Database>? _database;

  Future<Database> get database => _database ??= _openDatabase();

  Future<Database> _openDatabase() async {
    final path = join(await getDatabasesPath(), 'ecomind_parents.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // A single row with the session of the signed in parent
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
          'community_activity integer not null)',
        );
      },
    );
  }
}
