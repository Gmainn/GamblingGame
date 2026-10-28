import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/number_formatter.dart';
import '../../providers/game_provider.dart';
import '../widgets/slot_machine.dart';
import 'shop_screen.dart';
import 'slotdatabase.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Welcome-back message for offline earnings.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final earned = ref.read(offlineEarningsProvider);
      if (earned > 0 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Welcome back! You earned \$${formatNumber(earned)} while away.'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameProvider);
    final manager = ref.watch(upgradeManagerProvider);
    final perSec = manager.autoSpinsPerSecond(state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Slot Clicker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ShopScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.leaderboard),
            tooltip: 'Leaderboard',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LeaderboardPopup(),
              ),
            ),
          ),
        ],
      ),

    class LeaderboardPopup extends StatelessWidget {
      const LeaderboardPopup({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('🏆 Leaderboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          body: FutureBuilder<List<Map<String, Object?>>>(
            future: SlotMachineDatabase.instance.getLeaderboard(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final players = snapshot.data!;

              if (players.isEmpty) {
                return const Center(child: Text('No players yet!'));
              }

              return ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];

                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(player['name'].toString()),
                    subtitle: Text(
                      player['is_playing'] == 1
                        ? 'Currently playing'
                        : 'Offline',
                    ),
                    trailing: Text('${player['points']} pts'),
                  );
                },
              );
            },
          ),
        );
      }
    }



      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('\$${formatNumber(state.money)}',
                style: Theme.of(context).textTheme.displayMedium),
            Text('x${manager.payoutMultiplier(state).toStringAsFixed(2)} payout'
                '  •  ${perSec.toStringAsFixed(1)} auto pulls/s'),
            const SizedBox(height: 32),
            const SlotMachine(),
            const SizedBox(height: 32),
            // TODO: replace with a draggable Lever widget (ui/widgets/lever.dart)
            FilledButton.icon(
              style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
              onPressed: () => ref.read(gameProvider.notifier).pullLever(),
              icon: const Icon(Icons.casino),
              label: const Text('PULL', style: TextStyle(fontSize: 22)),
            ),
          ],
        ),
      ),
    );
  }
}
