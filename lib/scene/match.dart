import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:simple_western/config/global_config.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/scene/battle.dart';
import 'package:simple_western/object/player.dart';

class Match extends Component with HasGameRef {
  static const skyAsset = 'backgrounds/sky-bg.png';
  static const landAsset = 'backgrounds/land-bg.png';

  static final battleSize = Vector2(800, 320);
  final Vector2 battlePosition = Vector2.all(0);

  final Set<Player> _players;

  late SpriteComponent landComponent;
  late Battle battleLayer;
  late SpriteComponent skyComponent;

  Match(this._players) {
    debugMode = GlobalConfig.debugMode;
    skyComponent = SpriteComponent(anchor: Anchor.bottomCenter);
    landComponent = SpriteComponent(anchor: Anchor.topCenter);
    battleLayer = Battle(_players, battleSize, battlePosition);
  }

  @override
  Future<void> onLoad() async {
    skyComponent.sprite = await Sprite.load(skyAsset);
    skyComponent.size = skyComponent.sprite!.originalSize;
    landComponent.sprite = await Sprite.load(landAsset);
    landComponent.size = landComponent.sprite!.originalSize;

    resize(gameRef.canvasSize);

    await addAll({landComponent, skyComponent, battleLayer});
    await super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    resize(size);
    super.onGameResize(size);
  }

  void resize(Vector2 parentSize) {
    battlePosition.x = parentSize.x * 0.5;
    battlePosition.y = parentSize.y * 0.9 - 320;

    skyComponent.position = battlePosition + Vector2(0, 1);
    landComponent.position = battlePosition;
    battleLayer.position = battlePosition;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // final paint = Paint()..color = Colors.black;
    // canvas.drawRect(const Rect.fromLTWH(0, 0, 1280, 840), paint);
  }
}
