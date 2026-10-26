import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slot_clicker/app.dart';
import 'package:slot_clicker/models/game_state.dart';
import 'package:slot_clicker/providers/game_provider.dart';
import 'package:slot_clicker/services/save_service.dart';

class MockSaveService implements SaveService {
  @override
  GameState? load() => null;
  @override
  Future<void> save(GameState state) async {}
  @override
  Future<void> wipe() async {}
}

void main() {
  testWidgets('SlotClickerApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          saveServiceProvider.overrideWithValue(MockSaveService()),
          initialStateProvider.overrideWithValue(GameState.initial()),
          offlineEarningsProvider.overrideWithValue(0),
        ],
        child: const SlotClickerApp(),
      ),
    );

    expect(find.text('Slot Clicker'), findsOneWidget);
    expect(find.text('PULL'), findsOneWidget);
  });
}

