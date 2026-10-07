import 'package:flutter/material.dart';

import '../../data/upgrade_definitions.dart';
import '../widgets/upgrade_tile.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upgrades')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [for (final u in kUpgrades) UpgradeTile(u)],
      ),
    );
  }
}
