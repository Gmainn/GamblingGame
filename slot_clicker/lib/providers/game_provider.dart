import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants.dart';
import '../data/symbol_definitions.dart';
import '../data/upgrade_definitions.dart';
import '../logic/slot_engine.dart';
import '../logic/upgrade_manager.dart';
import '../models/game_state.dart';
import '../services/save_service.dart';

// Overridden in main.dart
final saveServiceProvider =
    Provider<SaveService>((ref) => throw UnimplementedError());
final initialStateProvider = Provider<GameState>((ref) => GameState.initial());
final offlineEarningsProvider = Provider<double>((ref) => 0);

final slotEngineProvider = Provider((ref) => SlotEngine(kSymbols));
final upgradeManagerProvider =
    Provider((ref) => const UpgradeManager(kUpgrades));
final lastSpinProvider = StateProvider<SpinResult?>((ref) => null);

final gameProvider =
    NotifierProvider<GameNotifier, GameState>(GameNotifier.new);

class GameNotifier extends Notifier<GameState> {
  Timer? _timer;
  double _spinAccumulator = 0;
  int _ticks = 0;

  @override
  GameState build() {
    _timer = Timer.periodic(kTick, (_) => _tick());
    ref.onDispose(() => _timer?.cancel());
    return ref.read(initialStateProvider);
  }

  UpgradeManager get _manager => ref.read(upgradeManagerProvider);

  /// Called by the lever.
  void pullLever() {
    HapticFeedback.mediumImpact();
    _spin();
  }

  void _spin() {
    final result =
        ref.read(slotEngineProvider).spin(luck: _manager.luck(state));
    final payout = result.basePayout * _manager.payoutMultiplier(state);
    ref.read(lastSpinProvider.notifier).state = result;
    state = state.copyWith(
      money: state.money + payout,
      totalSpins: state.totalSpins + 1,
    );
  }

  bool buyUpgrade(String id) {
    final next = _manager.purchase(id, state);
    if (next == null) return false;
    state = next;
    return true;
  }

  /// The one and only game loop: idle spins + autosave.
  void _tick() {
    final perSecond = _manager.autoSpinsPerSecond(state);
    _spinAccumulator += perSecond * (kTick.inMilliseconds / 1000);
    while (_spinAccumulator >= 1) {
      _spinAccumulator -= 1;
      _spin();
    }
    if (++_ticks % kAutosaveEveryTicks == 0) saveNow();
  }

  Future<void> saveNow() {
    state = state.copyWith(lastSaved: DateTime.now());
    return ref.read(saveServiceProvider).save(state);
  }
}
