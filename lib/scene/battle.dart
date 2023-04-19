import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/object/common_object.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/config/global_config.dart';
import 'package:simple_western/behavioral/bordarable.dart';
import 'package:simple_western/ui/player_bars.dart';

class Battle extends PositionComponent with Bordarable {
  static const _barStep = 16.0;
  static const _positionStep = 40.0;

  static final _commonObjects = [
    Vector2(100, 70),
    Vector2(160, 190),
    Vector2(320, 240),
    Vector2(345, 30),
    Vector2(650, 150),
    Vector2(550, 240),
  ];

  final Set<Player> _leftTeam;
  final Set<Player> _rightTeam;

  Battle(this._leftTeam, this._rightTeam, Vector2 size, Vector2 position)
      : super(size: size, position: position, anchor: Anchor.topCenter) {
    debugMode = GlobalConfig.debugMode;
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final commonObjects = CommonObject.getRandoms(_commonObjects);

    await addAll({RectangleHitbox(), ...commonObjects});

    _loadTeam(Anchor.bottomLeft, _leftTeam);
    _loadTeam(Anchor.bottomRight, _rightTeam);
  }

  void _loadTeam(Anchor anchor, Set<Player> team) {
    var parent = PositionComponent(anchor: anchor);
    var yPos = _positionStep * 2;
    var xPos = anchor.x == Anchor.centerLeft.x ? size.x * 0.3 : size.x * 0.7;

    var barsPosition = anchor.x == Anchor.centerRight.x
        ? Vector2(size.x + _barStep, size.y - _barStep)
        : Vector2(-_barStep, size.y - _barStep);

    for (final partner in team) {
      var bars = PlayerBars(partner, barsPosition);

      if (anchor.x == Anchor.centerRight.x) {
        partner.turnLeft();
        bars.flipHorizontally();
      }

      partner.position = Vector2(xPos, yPos);
      yPos += _positionStep;

      add(partner);
      parent.add(bars);

      barsPosition = Vector2(barsPosition.x, barsPosition.y += _barStep);
    }

    add(parent);
  }
}
