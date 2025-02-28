import 'package:flutter_test/flutter_test.dart';
import 'package:simple_western/game_app.dart';

void main() {
  testWidgets('GameApp starts without crashing', (WidgetTester tester) async {
    final game = GameApp();

    expect(() => game.onLoad(), returnsNormally);
  });
}
