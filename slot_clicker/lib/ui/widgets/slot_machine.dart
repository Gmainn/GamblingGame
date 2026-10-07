import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../providers/game_provider.dart';

/// Shows the three reels. Swap the AnimatedSwitcher for a real spinning
/// reel animation (see TODO) when you get to polish.
class SlotMachine extends ConsumerWidget {
  const SlotMachine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spin = ref.watch(lastSpinProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: spin?.isJackpot == true ? Colors.amber : Colors.white24,
          width: 3,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(kReelCount, (i) {
          final glyph = spin?.reels[i].glyph ?? '❓';
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            // TODO: replace with a Reel widget that scrolls through symbols.
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: Text(glyph,
                  key: ValueKey('$i$glyph'),
                  style: const TextStyle(fontSize: 56)),
            ),
          );
        }),
      ),
    );
  }
}
