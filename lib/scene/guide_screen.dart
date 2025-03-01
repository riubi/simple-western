import 'dart:async';

import 'package:flame/components.dart';
import 'package:simple_western/behavioral/dismissible.dart';
import 'package:simple_western/ui/text_builder.dart';

class GuideScreen extends PositionComponent
    with HasGameRef, KeyboardHandler, Dismissible {
  @override
  void Function() onDismiss;

  static const _defaultPadding = 40.0;

  GuideScreen(this.onDismiss);

  @override
  Future<void> onLoad() async {
    anchor = Anchor.topCenter;
    position = Vector2(gameRef.size.x / 2, 0);

    final title = TextComponent(
      text: 'Controls Guide',
      textRenderer: TextPaint(
        style: TextBuilder.buildStyle(true, fontSize: 38),
      ),
    );
    title.anchor = Anchor.topCenter;
    title.position = Vector2(0, _defaultPadding);

    final player1Text = TextComponent(
        text: 'Player 1:\n\nW,A,S,D - Move\nQ - Shoot\nE - Reload',
        textRenderer: TextPaint(
          style: TextBuilder.buildStyle(false, fontSize: 18),
        ),
        anchor: Anchor.topRight);

    final player2Text = TextComponent(
        text: 'Player 2:\n\nArrows - Move\nShift - Shoot\nEnter - Reload',
        textRenderer: TextPaint(
          style: TextBuilder.buildStyle(false, fontSize: 18),
        ),
        anchor: Anchor.topLeft);

    player1Text.position = Vector2(-_defaultPadding, 200);
    player2Text.position = Vector2(_defaultPadding, 200);

    final pressText = TextComponent(
        text: '<Press any key to continue>',
        textRenderer:
            TextPaint(style: TextBuilder.buildStyle(true, fontSize: 24)),
        anchor: Anchor.topCenter);

    pressText.position = Vector2(0, gameRef.size.y * 3 / 4);

    addAll([title, player1Text, player2Text, pressText]);

    await super.onLoad();
  }
}
