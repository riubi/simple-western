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
      : super(size: size, position: position) {
    debugMode = GlobalConfig.debugMode;

    _players.first.position = Vector2(size.x * 0.3, size.y * 0.3);
    _players.last.position = Vector2(size.x * 0.7, size.y * 0.3);
    _players.last.turnLeft();
  }

  @override
  FutureOr<void> onLoad() async {
    final commonObjects = CommonObject.getRandoms(
        [Vector2.all(100), Vector2.all(200), Vector2.all(300)]);

    await addAll({RectangleHitbox(), ..._players, ...commonObjects});
    return super.onLoad();
  }
}
