import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/symbol_definitions.dart';
import 'data/upgrade_definitions.dart';
import 'logic/offline_progress.dart';
import 'logic/slot_engine.dart';
import 'logic/upgrade_manager.dart';
import 'models/game_state.dart';
import 'providers/game_provider.dart';
import 'services/save_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final saveService = SaveService(prefs);

  // Load the save and grant offline earnings before the UI starts.
  var state = saveService.load() ?? GameState.initial();
  final offline = OfflineProgress.calculate(
    state: state,
    now: DateTime.now(),
    engine: SlotEngine(kSymbols),
    manager: UpgradeManager(kUpgrades),
  );
  state = state.copyWith(money: state.money + offline.earned);

  runApp(ProviderScope(
    overrides: [
      saveServiceProvider.overrideWithValue(saveService),
      initialStateProvider.overrideWithValue(state),
      offlineEarningsProvider.overrideWithValue(offline.earned),
    ],
    child: const SlotClickerApp(),
  ));
}
