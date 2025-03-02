import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:simple_western/entity/player.dart';

class HpBar extends PositionComponent {
  static const double barWidth = 28;
  static const double barHeight = 3;
  static const double borderWidth = 1;

  final Player player;
  final double maxHp;
  double currentHp;

  final RectangleComponent _border;
  final RectangleComponent _fill;

  HpBar(this.player)
      : maxHp = player.hp.toDouble(),
        currentHp = player.hp.toDouble(),
        _border = RectangleComponent(
          size:
              Vector2(barWidth + borderWidth * 2, barHeight + borderWidth * 2),
          paint: BasicPalette.black.paint(),
          anchor: Anchor.topLeft,
        ),
        _fill = RectangleComponent(
          size: Vector2(barWidth, barHeight),
          paint: BasicPalette.lightGreen.paint(),
          anchor: Anchor.topLeft,
          position: Vector2(borderWidth, borderWidth),
        ) {
    player.addDamageHandler(_onDamage);
  }

  @override
  Future<void> onLoad() async {
    await addAll([_border, _fill]);

    return super.onLoad();
  }

  void _onDamage(int hp) {
    currentHp = hp.toDouble();
    double newWidth = (currentHp / maxHp) * barWidth;
    _fill.size.x = newWidth.clamp(0, barWidth);
  }
}
