import '../models/game_state.dart';
import '../models/upgrade.dart';

/// Cost scaling, purchase rules, and turning owned upgrades into stats.
class UpgradeManager {
  final List<Upgrade> upgrades;
  const UpgradeManager(this.upgrades);

  Upgrade byId(String id) => upgrades.firstWhere((u) => u.id == id);

  double costOf(Upgrade u, GameState s) => u.costAt(s.ownedCount(u.id));

  bool canAfford(Upgrade u, GameState s) => s.money >= costOf(u, s);

  /// Returns the new state, or null if the purchase isn't possible.
  GameState? purchase(String id, GameState s) {
    final u = byId(id);
    final cost = costOf(u, s);
    if (s.money < cost) return null;
    return s.copyWith(
      money: s.money - cost,
      owned: {...s.owned, id: s.ownedCount(id) + 1},
    );
  }

  double _sum(GameState s, UpgradeType type) => upgrades
      .where((u) => u.type == type)
      .fold(0.0, (sum, u) => sum + u.effect * s.ownedCount(u.id));

  /// Add a getter here when you add an UpgradeType.
  double payoutMultiplier(GameState s) =>
      1 + _sum(s, UpgradeType.payoutMultiplier);
  double autoSpinsPerSecond(GameState s) => _sum(s, UpgradeType.autoSpin);
  double luck(GameState s) => _sum(s, UpgradeType.luck);
}
