import 'dart:async';

import 'package:flame/components.dart';
import 'package:simple_western/behavioral/dismissible.dart';
import 'package:simple_western/ui/menu_builder.dart';

class GuideScreen extends PositionComponent
    with HasGameRef, KeyboardHandler, Dismissible {
  @override
  void Function() onDismiss;

  GuideScreen(this.onDismiss);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final title = TextComponent(
      text: 'Controls Guide',
      textRenderer: TextPaint(
        style: MenuBuilder.buildStyle(true, fontSize: 38),
      ),
    );

    title.position = gameRef.size / 2 + Vector2(-title.scaledSize.x / 2, -200);

    final player1Text = TextComponent(
      text: 'Player 1:\n\nW,A,S,D - Move\nQ - Shoot\nE - Reload',
      textRenderer: TextPaint(
        style: MenuBuilder.buildStyle(false, fontSize: 18),
      ),
    )..position = gameRef.size / 2 + Vector2(-250, -100);

    final player2Text = TextComponent(
      text: 'Player 2:\n\nArrows - Move\nShift - Shoot\nEnter - Reload',
      textRenderer: TextPaint(
        style: MenuBuilder.buildStyle(false, fontSize: 18),
      ),
    )..position = gameRef.size / 2 + Vector2(50, -100);

    final pressText = TextComponent(
      text: '<Press any key to continue>',
      textRenderer: TextPaint(
        style: MenuBuilder.buildStyle(true, fontSize: 24),
      ),
    );

    pressText.position =
        gameRef.size / 2 + Vector2(-pressText.scaledSize.x / 2, 150);

    addAll([title, player1Text, player2Text, pressText]);
  }
}
