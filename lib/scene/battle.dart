import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/object/common_object.dart';
import 'package:simple_western/ui/clip_bar.dart';
import 'package:simple_western/ui/hp_bar.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/config/global_config.dart';
import 'package:simple_western/behavioral/bordarable.dart';

class Battle extends PositionComponent with Bordarable {
  static const _barOffset = 30.0;
  static const _barStep = 16.0;
  static const _positionStep = 40.0;

  final Set<Player> _leftTeam;
  final Set<Player> _rightTeam;

  Battle(this._leftTeam, this._rightTeam, Vector2 size, Vector2 position)
      : super(size: size, position: position, anchor: Anchor.topCenter) {
    debugMode = GlobalConfig.debugMode;
  }

  void _loadTeam(Anchor anchor, Set<Player> team) {
    var yPos = _positionStep * 2;
    var xPos = anchor.x == Anchor.centerLeft.x ? size.x * 0.3 : size.x * 0.7;

    var xBarPos =
        anchor.x == Anchor.centerLeft.x ? _barOffset : size.x - _barOffset;

    var hpPosition = Vector2(xBarPos, size.y - _barOffset);
    var clipPosition = Vector2(xBarPos - _barOffset, size.y - _barOffset / 3);

    for (final partner in team) {
      if (anchor.x == Anchor.centerRight.x) {
        partner.turnLeft();
      }

      partner.position = Vector2(xPos, yPos);
      yPos += _positionStep;

      add(partner);
      add(HpBar(partner, hpPosition, anchor));
      add(ClipBar(partner.gun, clipPosition, anchor));

      hpPosition = Vector2(hpPosition.x, hpPosition.y += _barStep);
      clipPosition = Vector2(clipPosition.x, clipPosition.y += _barStep);
    }
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final commonObjects = CommonObject.getRandoms([
      Vector2(100, 70),
      Vector2(160, 190),
      Vector2(320, 240),
      Vector2(345, 30),
      Vector2(650, 150),
      Vector2(550, 240),
    ]);

    await addAll({RectangleHitbox(), ...commonObjects});

    _loadTeam(Anchor.bottomLeft, _leftTeam);
    _loadTeam(Anchor.bottomRight, _rightTeam);
  }
}
