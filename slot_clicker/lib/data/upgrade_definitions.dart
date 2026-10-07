import '../models/upgrade.dart';

/// Add a new upgrade = add one entry here.
const List<Upgrade> kUpgrades = [
  Upgrade(
    id: 'lucky_coin',
    name: 'Lucky Coin',
    description: '+10% payout per level',
    baseCost: 15,
    costGrowth: 1.15,
    type: UpgradeType.payoutMultiplier,
    effect: 0.10,
  ),
  Upgrade(
    id: 'auto_pull',
    name: 'Auto Puller',
    description: '+0.2 automatic pulls per second',
    baseCost: 50,
    costGrowth: 1.15,
    type: UpgradeType.autoSpin,
    effect: 0.2,
  ),
  Upgrade(
    id: 'clover_charm',
    name: 'Four-Leaf Charm',
    description: 'Rare symbols appear 5% more often per level',
    baseCost: 200,
    costGrowth: 1.25,
    type: UpgradeType.luck,
    effect: 0.05,
  ),
  Upgrade(
    id: 'gold_lever',
    name: 'Golden Lever',
    description: '+100% payout per level',
    baseCost: 1500,
    costGrowth: 1.2,
    type: UpgradeType.payoutMultiplier,
    effect: 1.0,
  ),
];
