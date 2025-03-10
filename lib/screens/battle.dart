import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/behavioral/borderable.dart';
import 'package:simple_western/entity/player.dart';
import 'package:simple_western/interface/player_bars.dart';
import 'package:simple_western/object/common_object.dart';

class Battle extends PositionComponent with Borderable {
  static const _barStep = 16.0;
  static const _positionStep = 40.0;
  static const _leftPositionFactor = .3;
  static const _rightPositionFactor = .7;

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
      : super(size: size, position: position, anchor: Anchor.topCenter);

  @override
  FutureOr<void> onLoad() async {
    final commonObjects = CommonObject.getRandoms(_commonObjects);

    _loadTeam(Anchor.bottomLeft, _leftTeam);
    _loadTeam(Anchor.bottomRight, _rightTeam);

    await addAll({RectangleHitbox(), ...commonObjects});

    await super.onLoad();
  }

  void _loadTeam(Anchor anchor, Set<Player> team) async {
    var yPos = _positionStep * 2;
    var xPos = anchor.x == Anchor.centerLeft.x
        ? size.x * _leftPositionFactor
        : size.x * _rightPositionFactor;

    for (final player in team) {
      var bars = PlayerBars(player, Vector2(-_barStep, -_barStep));

      if (anchor.x == Anchor.centerRight.x) {
        player.turnLeft();
      }

      player.position = Vector2(xPos, yPos);
      yPos += _positionStep;

      await player.add(bars);
    }

    await addAll(team);
  }
}
