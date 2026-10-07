import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/game_provider.dart';
import 'ui/screens/game_screen.dart';

class SlotClickerApp extends ConsumerStatefulWidget {
  const SlotClickerApp({super.key});

  @override
  ConsumerState<SlotClickerApp> createState() => _SlotClickerAppState();
}

class _SlotClickerAppState extends ConsumerState<SlotClickerApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Save whenever the app leaves the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      ref.read(gameProvider.notifier).saveNow();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slot Clicker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.amber,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}
