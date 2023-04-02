import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/player.dart';
import 'package:simple_western/global_config.dart';
import 'package:simple_western/behavioral/position_bordarable.dart';

class BattlePosition extends PositionComponent with PositionBordarable {
  final Set<Player> _players;

  BattlePosition(this._players, size, position): super(size: size, position: position) {
    debugMode = GlobalConfig.debugMode;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _players.first.position = Vector2(size.x * 0.3, size.y * 0.3);
    _players.last.position = Vector2(size.x * 0.7, size.y * 0.3);
    _players.last.turnLeft();

    addAll({RectangleHitbox(), ..._players});
  }
}