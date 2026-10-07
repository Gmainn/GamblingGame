import 'dart:math';

/// Add new effect types here, then handle them in UpgradeManager.
enum UpgradeType { payoutMultiplier, autoSpin, luck }

class Upgrade {
  final String id;
  final String name;
  final String description;
  final double baseCost;
  final double costGrowth;
  final UpgradeType type;
  final double effect; // per level owned

  const Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.baseCost,
    required this.costGrowth,
    required this.type,
    required this.effect,
  });

  double costAt(int owned) => baseCost * pow(costGrowth, owned);
}
