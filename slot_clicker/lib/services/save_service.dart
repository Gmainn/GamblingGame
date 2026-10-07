import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_state.dart';

class SaveService {
  static const _key = 'game_save';
  final SharedPreferences _prefs;
  SaveService(this._prefs);

  GameState? load() {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    try {
      return GameState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null; // corrupted save -> start fresh
    }
  }

  Future<void> save(GameState state) =>
      _prefs.setString(_key, jsonEncode(state.toJson()));

  Future<void> wipe() => _prefs.remove(_key);
}
