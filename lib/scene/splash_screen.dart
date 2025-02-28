import 'dart:async';

import 'package:flame/components.dart';
import 'package:simple_western/behavioral/dismissible.dart';
import 'package:simple_western/ui/text_builder.dart';

class SplashScreen extends PositionComponent
    with HasGameRef, KeyboardHandler, Dismissible {
  static const logoAsset = 'ui/logo.png';

  @override
  void Function() onDismiss;

  SplashScreen(this.onDismiss);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final logo = SpriteComponent()
      ..sprite = await gameRef.loadSprite(logoAsset)
      ..size = Vector2(650, 96)
      ..position = gameRef.size / 2 - Vector2(325, 88);

    final pressText = TextComponent(
      text: '<Press any key to continue>',
      textRenderer:
          TextPaint(style: TextBuilder.buildStyle(true, fontSize: 24)),
    );

    pressText.position =
        gameRef.size / 2 + Vector2(-pressText.scaledSize.x / 2, 80);

    addAll([logo, pressText]);
  }
}
