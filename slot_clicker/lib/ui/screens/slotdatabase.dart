import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LeaderboardDatabase {
  // Singleton database instance
  static final LeaderboardDatabase instance =
  LeaderboardDatabase._init();

  static Database? _database;

  LeaderboardDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('leaderboard.db');
    return _database!;
  }

  // Create the database and leaderboard table
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE leaderboard (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            player_name TEXT NOT NULL,
            score INTEGER NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Save a player's score
  Future<int> addScore({
    required String playerName,
    required int score,
  }) async {
    if (playerName.trim().isEmpty) {
      throw ArgumentError('Player name cannot be empty.');
    }

    if (score < 0) {
      throw ArgumentError('Score cannot be negative.');
    }

    final db = await database;

    return await db.insert('leaderboard', {
      'player_name': playerName.trim(),
      'score': score,
      'date': DateTime.now().toIso8601String(),
    });
  }

  // Get the highest scores first
  Future<List<Map<String, Object?>>> getLeaderboard({
    int limit = 10,
  }) async {
    if (limit <= 0) {
      throw ArgumentError('Limit must be greater than zero.');
    }

    final db = await database;

    return await db.query(
      'leaderboard',
      orderBy: 'score DESC, date ASC, id ASC',
      limit: limit,
    );
  }

  // Get all scores for a particular player
  Future<List<Map<String, Object?>>> getPlayerScores(
      String playerName,
      ) async {
    final db = await database;

    return await db.query(
      'leaderboard',
      where: 'player_name = ?',
      whereArgs: [playerName.trim()],
      orderBy: 'score DESC, date ASC',
    );
  }

  // Delete one score by its ID
  Future<int> deleteScore(int id) async {
    final db = await database;

    return await db.delete(
      'leaderboard',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
