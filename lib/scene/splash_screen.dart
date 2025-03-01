import 'dart:async';

import 'package:flame/components.dart';
import 'package:simple_western/behavioral/dismissible.dart';
import 'package:simple_western/ui/text_builder.dart';

class SplashScreen extends PositionComponent
    with HasGameRef, KeyboardHandler, Dismissible {
  static const logoAsset = 'ui/logo.png';
  static const _logoWidth = 650.0;
  static const _logoHeight = 96.0;
  static const _defaultPadding = 40.0;

  @override
  void Function() onDismiss;

  SplashScreen(this.onDismiss);

  @override
  Future<void> onLoad() async {
    anchor = Anchor.topCenter;
    position = Vector2(gameRef.size.x / 2, 0);

    final logo = SpriteComponent()
      ..sprite = await gameRef.loadSprite(logoAsset)
      ..size = Vector2(_logoWidth, _logoHeight)
      ..anchor = Anchor.topCenter
      ..position = Vector2(0, _defaultPadding);

    final pressText = TextComponent(
      text: '<Press any key to continue>',
      textRenderer:
          TextPaint(style: TextBuilder.buildStyle(true, fontSize: 24)),
    );

    pressText
      ..anchor = Anchor.topCenter
      ..position = Vector2(0, gameRef.size.y * 3 / 4);

    addAll([logo, pressText]);

    await super.onLoad();
  }
}
