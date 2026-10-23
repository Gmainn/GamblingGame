
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SlotMachineDatabase {
  static final SlotMachineDatabase instance =
  SlotMachineDatabase._init();

  static Database? _database;

  SlotMachineDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('slot_machine.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        points INTEGER NOT NULL DEFAULT 100,
        is_playing INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE spin_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        item1 TEXT NOT NULL,
        item2 TEXT NOT NULL,
        item3 TEXT NOT NULL,
        points_earned INTEGER NOT NULL,
        played_at TEXT NOT NULL,
        FOREIGN KEY (player_id) REFERENCES players(id)
      )
    ''');
  }

  // Add a player with 100 starting points.
  Future<int> addPlayer(String name) async {
    final db = await database;

    return await db.insert(
      'players',
      {
        'name': name.trim(),
        'points': 100,
        'is_playing': 1,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // Mark a player as currently playing or offline.
  Future<int> setPlaying(int playerId, bool playing) async {
    final db = await database;

    return await db.update(
      'players',
      {'is_playing': playing ? 1 : 0},
      where: 'id = ?',
      whereArgs: [playerId],
    );
  }

  // Retrieve the leaderboard.
  Future<List<Map<String, Object?>>> getLeaderboard() async {
    final db = await database;

    return await db.query(
      'players',
      orderBy: 'points DESC, name ASC',
    );
  }

  // Show only players currently playing.
  Future<List<Map<String, Object?>>> getActivePlayers() async {
    final db = await database;

    return await db.query(
      'players',
      where: 'is_playing = ?',
      whereArgs: [1],
      orderBy: 'points DESC',
    );
  }

  // Read one player's current points.
  Future<int?> getPoints(int playerId) async {
    final db = await database;

    final result = await db.query(
      'players',
      columns: ['points'],
      where: 'id = ?',
      whereArgs: [playerId],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return result.first['points'] as int;
  }

  // Save the three slot items and update the score.
  Future<void> recordSpin({
    required int playerId,
    required String item1,
    required String item2,
    required String item3,
    required int pointsEarned,
  }) async {
    final db = await database;

    await db.transaction((txn) async {
      final players = await txn.query(
        'players',
        columns: ['points'],
        where: 'id = ?',
        whereArgs: [playerId],
        limit: 1,
      );

      if (players.isEmpty) {
        throw Exception('Player not found.');
      }

      final currentPoints = players.first['points'] as int;
      final newPoints = currentPoints + pointsEarned;

      if (newPoints < 0) {
        throw Exception('Not enough points.');
      }

      await txn.update(
        'players',
        {'points': newPoints},
        where: 'id = ?',
        whereArgs: [playerId],
      );

      await txn.insert('spin_history', {
        'player_id': playerId,
        'item1': item1,
        'item2': item2,
        'item3': item3,
        'points_earned': pointsEarned,
        'played_at': DateTime.now().toIso8601String(),
      });
    });
  }

  // Retrieve a player's spin history.
  Future<List<Map<String, Object?>>> getSpinHistory(
      int playerId) async {
    final db = await database;

    return await db.query(
      'spin_history',
      where: 'player_id = ?',
      whereArgs: [playerId],
      orderBy: 'played_at DESC',
    );
  }

  // Close the database when it is no longer needed.
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
