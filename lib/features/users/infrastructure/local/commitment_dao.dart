import 'package:ecomind_parents/core/app_database.dart';
import 'package:sqflite/sqflite.dart';

class CommitmentDao {
  final AppDatabase appDatabase;
  const new({required this.appDatabase});

  // One row per user: the id of the row is the account id
  Future<String?> getCommitment(int accountId) async {
    Database database = await appDatabase.database;
    List<Map<String, Object?>> maps = await database.query(
      'personal_commitment',
      where: 'id = ?',
      whereArgs: [accountId],
    );
    if (maps.isEmpty) {
      return null;
    }
    return maps.first['text'] as String;
  }

  Future<void> saveCommitment(int accountId, String text) async {
    Database database = await appDatabase.database;
    await database.insert('personal_commitment', {
      'id': accountId,
      'text': text,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
