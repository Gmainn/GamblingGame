/// Game-wide tuning values. Keep magic numbers here.
const Duration kTick = Duration(milliseconds: 100);
const int kAutosaveEveryTicks = 150; // 150 * 100ms = 15s
const int kSaveVersion = 1;
const double kStartingMoney = 0;
const int kReelCount = 3;
const double kOfflineCapHours = 8;
const double kOfflineEfficiency = 0.5; // offline earns half as much
