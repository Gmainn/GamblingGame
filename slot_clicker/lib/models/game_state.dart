import '../core/constants.dart';

/// Immutable snapshot of the player's progress.
class GameState {
  final double money;
  final int totalSpins;
  final Map<String, int> owned; // upgrade id -> level
  final DateTime lastSaved;
  final int saveVersion;

  const GameState({
    required this.money,
    required this.totalSpins,
    required this.owned,
    required this.lastSaved,
    this.saveVersion = kSaveVersion,
  });

  factory GameState.initial() => GameState(
        money: kStartingMoney,
        totalSpins: 0,
        owned: const {},
        lastSaved: DateTime.now(),
      );

  int ownedCount(String id) => owned[id] ?? 0;

  GameState copyWith({
    double? money,
    int? totalSpins,
    Map<String, int>? owned,
    DateTime? lastSaved,
  }) =>
      GameState(
        money: money ?? this.money,
        totalSpins: totalSpins ?? this.totalSpins,
        owned: owned ?? this.owned,
        lastSaved: lastSaved ?? this.lastSaved,
        saveVersion: saveVersion,
      );

  Map<String, dynamic> toJson() => {
        'saveVersion': saveVersion,
        'money': money,
        'totalSpins': totalSpins,
        'owned': owned,
        'lastSaved': lastSaved.toIso8601String(),
      };

  factory GameState.fromJson(Map<String, dynamic> json) {
    // Migrate old save formats here when saveVersion changes:
    // final version = json['saveVersion'] as int? ?? 1;
    final rawOwned = (json['owned'] as Map?) ?? {};
    return GameState(
      money: (json['money'] as num?)?.toDouble() ?? 0,
      totalSpins: (json['totalSpins'] as num?)?.toInt() ?? 0,
      owned: rawOwned.map((k, v) => MapEntry(k as String, (v as num).toInt())),
      lastSaved:
          DateTime.tryParse(json['lastSaved'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
