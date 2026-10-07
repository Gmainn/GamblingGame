import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/number_formatter.dart';
import '../../models/upgrade.dart';
import '../../providers/game_provider.dart';

class UpgradeTile extends ConsumerWidget {
  final Upgrade upgrade;
  const UpgradeTile(this.upgrade, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);
    final manager = ref.watch(upgradeManagerProvider);
    final cost = manager.costOf(upgrade, state);
    final affordable = manager.canAfford(upgrade, state);

    return Card(
      child: ListTile(
        title: Text('${upgrade.name}  (Lv ${state.ownedCount(upgrade.id)})'),
        subtitle: Text(upgrade.description),
        trailing: FilledButton(
          onPressed: affordable
              ? () => ref.read(gameProvider.notifier).buyUpgrade(upgrade.id)
              : null,
          child: Text('\$${formatNumber(cost)}'),
        ),
      ),
    );
  }
}
