import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:simple_western/audio_manager.dart';
import 'package:simple_western/battle_position.dart';
import 'package:simple_western/player.dart';
import 'package:simple_western/global_config.dart';

class BattleScene extends Component {
  final Set<Player> _players;
  late final Sprite _backgroundSprite;

  BattleScene(this._players) {
    debugMode = GlobalConfig.debugMode;
  }

  @override
  Future<void> onLoad() async {
    AudioManager.playMatchAudio();

    await super.onLoad();

    add(BattlePosition(_players, Vector2(800, 320), Vector2(180, 480)));

    _backgroundSprite = await Sprite.load('backgrounds/background-1.png');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()..color = Colors.black;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 1280, 840), paint);

    _backgroundSprite.render(
      canvas,
      position: Vector2(0, 0),
      size: Vector2(1280, 840),
    );
  }
}
