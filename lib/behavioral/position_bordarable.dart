import 'dart:ui';
import 'package:flame/components.dart';
import 'package:simple_western/behavioral/position_inhiber.dart';

mixin PositionBordarable on PositionComponent implements PositionInhiber {
  @override
  Offset inhib(PositionComponent movable, Offset positionDelta) {
    if (positionDelta.dy != 0) {
      final double top = movable.position.y + positionDelta.dy;
      final double bottom = top + movable.size.y;

      if (top < 0 || bottom > size.y) {
        positionDelta = Offset(positionDelta.dx, 0.0);
      }
    }

    if (positionDelta.dx != 0.0) {
      final double left = movable.position.x + positionDelta.dx;
      final double right = left + movable.size.x;

      if (left < 0 || right > size.x) {
        positionDelta = Offset(0.0, positionDelta.dy);
      }
    }

    return positionDelta;
  }
}