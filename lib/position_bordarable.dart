import 'dart:ui';
import 'package:flame/components.dart';

mixin PositionBordarable on PositionComponent {
  Offset inhib(PositionComponent checkingObject, Offset delta) {
    if (delta.dy != 0) {
      final double top = checkingObject.position.y + delta.dy;
      final double bottom = top + checkingObject.size.y;

      if (top < 0 || bottom > size.y) {
        delta = Offset(delta.dx, 0.0);
      }
    }

    if (delta.dx != 0.0) {
      final double left = checkingObject.position.x + delta.dx;
      final double right = left + checkingObject.size.x;

      if (left < 0 || right > size.x) {
        delta = Offset(0.0, delta.dy);
      }
    }

    return delta;
  }
}