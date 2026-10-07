import 'dart:math';

import '../core/constants.dart';
import '../models/slot_symbol.dart';

class SpinResult {
  final List<SlotSymbol> reels;
  final double basePayout; // before upgrade multipliers
  const SpinResult(this.reels, this.basePayout);

  bool get isJackpot => reels.every((s) => s.id == reels.first.id);
}

/// Pure Dart. Pass a seeded Random in tests for reproducible spins.
class SlotEngine {
  final List<SlotSymbol> symbols;
  final Random _rng;

  SlotEngine(this.symbols, {Random? random}) : _rng = random ?? Random();

  SpinResult spin({double luck = 0}) {
    final reels = List.generate(kReelCount, (_) => _pick(luck));
    return SpinResult(reels, payoutFor(reels));
  }

  /// Payout rules. Edit this to change how combinations pay.
  /// - 3 of a kind: symbol payout
  /// - pair: 20% of that symbol's payout (min 1)
  /// - no match: 1 (so every pull always feels like progress)
  double payoutFor(List<SlotSymbol> reels) {
    final counts = <String, int>{};
    for (final s in reels) {
      counts[s.id] = (counts[s.id] ?? 0) + 1;
    }
    final best = counts.values.reduce(max);
    if (best == reels.length) return reels.first.payout;
    if (best == 2) {
      final pairId = counts.entries.firstWhere((e) => e.value == 2).key;
      final pair = reels.firstWhere((s) => s.id == pairId);
      return max(1, pair.payout * 0.2);
    }
    return 1;
  }

  SlotSymbol _pick(double luck) {
    double weightOf(SlotSymbol s) =>
        s.isRare ? s.weight * (1 + luck) : s.weight.toDouble();
    final total = symbols.fold<double>(0, (sum, s) => sum + weightOf(s));
    var roll = _rng.nextDouble() * total;
    for (final s in symbols) {
      roll -= weightOf(s);
      if (roll <= 0) return s;
    }
    return symbols.last;
  }

  /// Average base payout per spin (no luck). Used for offline earnings.
  double expectedPayout() {
    final total = symbols.fold<double>(0, (sum, s) => sum + s.weight);
    var ev = 0.0;
    for (final a in symbols) {
      for (final b in symbols) {
        for (final c in symbols) {
          final p =
              (a.weight / total) * (b.weight / total) * (c.weight / total);
          ev += p * payoutFor([a, b, c]);
        }
      }
    }
    return ev;
  }
}
