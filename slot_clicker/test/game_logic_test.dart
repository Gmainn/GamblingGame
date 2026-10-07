import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:slot_clicker/data/symbol_definitions.dart';
import 'package:slot_clicker/data/upgrade_definitions.dart';
import 'package:slot_clicker/logic/slot_engine.dart';
import 'package:slot_clicker/logic/upgrade_manager.dart';
import 'package:slot_clicker/models/game_state.dart';

void main() {
  test('seeded engine is reproducible', () {
    final a = SlotEngine(kSymbols, random: Random(42)).spin();
    final b = SlotEngine(kSymbols, random: Random(42)).spin();
    expect(a.reels.map((s) => s.id), b.reels.map((s) => s.id));
  });

  test('every spin pays at least 1', () {
    final engine = SlotEngine(kSymbols, random: Random(1));
    for (var i = 0; i < 500; i++) {
      expect(engine.spin().basePayout, greaterThanOrEqualTo(1));
    }
  });

  test('upgrade cost scales and purchase deducts money', () {
    const manager = UpgradeManager(kUpgrades);
    var state = GameState.initial().copyWith(money: 1000);
    final u = kUpgrades.first;
    final firstCost = manager.costOf(u, state);
    state = manager.purchase(u.id, state)!;
    expect(state.ownedCount(u.id), 1);
    expect(state.money, closeTo(1000 - firstCost, 0.001));
    expect(manager.costOf(u, state), greaterThan(firstCost));
  });

  test('cannot buy what you cannot afford', () {
    const manager = UpgradeManager(kUpgrades);
    expect(manager.purchase(kUpgrades.first.id, GameState.initial()), isNull);
  });

  test('save round-trips through json', () {
    final s = GameState.initial()
        .copyWith(money: 123.5, totalSpins: 7, owned: {'lucky_coin': 3});
    final back = GameState.fromJson(s.toJson());
    expect(back.money, 123.5);
    expect(back.owned['lucky_coin'], 3);
  });
}
