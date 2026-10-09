  lib/
├── main.dart
├── app.dart                  			# MaterialApp, routes, theme
├── core/
│   ├── constants.dart
│   ├── number_formatter.dart 		# 1.2K, 3.4M, etc.
│   └── game_loop.dart       			 # Ticker for idle income
├── data/                     			# Static game content (easy to expand)
│   ├── upgrade_definitions.dart
│   └── symbol_definitions.dart
├── models/
│   ├── game_state.dart      			 # money, lever pulls, owned upgrades
│   ├── upgrade.dart
│   └── slot_symbol.dart
├── logic/                    			# Pure Dart, no Flutter imports
│   ├── slot_engine.dart      			# Spin results and payouts
│   ├── upgrade_manager.dart 		 # Cost scaling, purchase rules
│   └── offline_progress.dart
├── services/
│   ├── save_service.dart
│   └── audio_service.dart
├── providers/
│   └── game_provider.dart    		# Connects logic to UI
└── ui/
    ├── screens/
    │   ├── game_screen.dart
    │   ├── shop_screen.dart
    │   └── settings_screen.dart
    └── widgets/
        ├── slot_machine.dart
        ├── lever.dart
        ├── reel.dart
        └── upgrade_tile.dart
