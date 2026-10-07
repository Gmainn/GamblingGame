# Slot Clicker (starter scaffold)

## Setup
1. In Android Studio: File > New > New Flutter Project, name it `slot_clicker`.
2. Replace its `lib/`, `test/`, and `pubspec.yaml` with the ones from this scaffold.
3. Run `flutter pub get`, then run the app and `flutter test`.

## Where to add things
- New symbol:      `lib/data/symbol_definitions.dart`
- New upgrade:     `lib/data/upgrade_definitions.dart`
- New effect type: add to `UpgradeType`, then a getter in `UpgradeManager`
- Payout rules:    `SlotEngine.payoutFor`
- Tuning numbers:  `lib/core/constants.dart`

## Next steps (TODOs in code)
- Draggable Lever widget + spinning Reel widget
- Audio service, settings screen
- Prestige, achievements, extra machines
