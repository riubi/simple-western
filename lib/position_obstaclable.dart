import 'dart:ui';
import 'package:flame/components.dart';

mixin PositionObstaclable on PositionComponent {
  Offset inhib(PositionComponent checkingObject, Offset delta) {
    // @TODO fix collision issue when both targets in move.

    if (delta.dy != 0 && !_isMovementBlocked(position.y, checkingObject.position.y, size.y, checkingObject.size.y, delta.dy)) {
      delta = Offset(delta.dx, 0);
    }

    if (delta.dx != 0 && !_isMovementBlocked(position.x, checkingObject.position.x, size.x, checkingObject.size.x, delta.dx)) {
      delta = Offset(0, delta.dy);
    }

    return delta;
  }

  bool _isMovementBlocked(double pos1, double pos2, double size1, double size2, double delta) {
    final double newPos1 = pos1 + delta;
    return !(newPos1 > pos2 + size2 || newPos1 + size1 < pos2);
  }
}