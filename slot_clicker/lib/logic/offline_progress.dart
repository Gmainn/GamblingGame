import 'dart:math';

import '../core/constants.dart';
import '../models/game_state.dart';
import 'slot_engine.dart';
import 'upgrade_manager.dart';

class OfflineResult {
  final double earned;
  final Duration away;
  const OfflineResult(this.earned, this.away);
}

class OfflineProgress {
  static OfflineResult calculate({
    required GameState state,
    required DateTime now,
    required SlotEngine engine,
    required UpgradeManager manager,
  }) {
    final away = now.difference(state.lastSaved);
    if (away.isNegative) return const OfflineResult(0, Duration.zero);

    final seconds = min(away.inSeconds.toDouble(), kOfflineCapHours * 3600);
    final spins = manager.autoSpinsPerSecond(state) * seconds;
    final earned = spins *
        engine.expectedPayout() *
        manager.payoutMultiplier(state) *
        kOfflineEfficiency;
    return OfflineResult(earned, away);
  }
}
