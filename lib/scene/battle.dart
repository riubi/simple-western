import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/object/common_object.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/config/global_config.dart';
import 'package:simple_western/behavioral/bordarable.dart';

class Battle extends PositionComponent with Bordarable {
  final Set<Player> _players;

  Battle(this._players, size, position)
      : super(size: size, anchor: Anchor.topCenter) {
    debugMode = GlobalConfig.debugMode;

    _players.first.position = Vector2(size.x * 0.3, size.y * 0.3);
    _players.last.position = Vector2(size.x * 0.7, size.y * 0.3);
    _players.last.turnLeft();
  }

  @override
  FutureOr<void> onLoad() async {
    final commonObjects = CommonObject.getRandoms([
      Vector2(100, 70),
      Vector2(160, 190),
      Vector2(320, 240),
      Vector2(345, 35),
      Vector2(650, 150),
      Vector2(550, 240),
    ]);

    await addAll({RectangleHitbox(), ..._players, ...commonObjects});
    return super.onLoad();
  }
}
