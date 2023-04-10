import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/object/common_object.dart';
import 'package:simple_western/ui/hp_bar.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/config/global_config.dart';
import 'package:simple_western/behavioral/bordarable.dart';

class Battle extends PositionComponent with Bordarable {
  static const _hpBarOffset = 30.0;
  static const _hpBarStep = 13.0;
  static const _positionStep = 40.0;
  final Set<Player> _leftTeam;
  final Set<Player> _rightTeam;

  Battle(this._leftTeam, this._rightTeam, size, position)
      : super(size: size, position: position, anchor: Anchor.topCenter) {
    debugMode = GlobalConfig.debugMode;
  }

  void _loadTeam(Anchor anchor, Set<Player> team) {
    var yPos = _positionStep;
    var xPos = anchor == Anchor.bottomLeft ? size.x * 0.3 : size.x * 0.7;

    var xHpPos =
        anchor == Anchor.bottomLeft ? _hpBarOffset : size.x - _hpBarOffset;
    var hpPosition = Vector2(xHpPos, size.y - _hpBarOffset);

    for (var partner in team) {
      if (anchor == Anchor.bottomRight) {
        partner.turnLeft();
      }

      partner.position = Vector2(xPos, yPos);
      yPos += _positionStep;

      add(partner);
      add(HpBar(partner, hpPosition, anchor));

      hpPosition = Vector2(hpPosition.x, hpPosition.y += _hpBarStep);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final commonObjects = CommonObject.getRandoms([
      Vector2(100, 70),
      Vector2(160, 190),
      Vector2(320, 240),
      Vector2(345, 35),
      Vector2(650, 150),
      Vector2(550, 240),
    ]);

    await addAll({RectangleHitbox(), ...commonObjects});

    _loadTeam(Anchor.bottomLeft, _leftTeam);
    _loadTeam(Anchor.bottomRight, _rightTeam);
  }
}
