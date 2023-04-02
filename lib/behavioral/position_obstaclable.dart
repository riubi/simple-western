import 'dart:ui';
import 'package:flame/components.dart';
import 'package:simple_western/behavioral/position_inhiber.dart';

mixin PositionObstaclable on PositionComponent implements PositionInhiber {
  @override
  Offset inhib(PositionComponent movable, Offset positionDelta) {
    // @TODO fix collision issue when both targets in move.
    if (positionDelta.dy != 0 &&
        !_isMovementBlocked(position.y, movable.position.y, size.y,
            movable.size.y, positionDelta.dy)) {
      positionDelta = Offset(positionDelta.dx, 0);
    }

    if (positionDelta.dx != 0 &&
        !_isMovementBlocked(position.x, movable.position.x, size.x,
            movable.size.x, positionDelta.dx)) {
      positionDelta = Offset(0, positionDelta.dy);
    }

    return positionDelta;
  }

  bool _isMovementBlocked(
      double pos1, double pos2, double size1, double size2, double delta) {
    final double newPos1 = pos1 + delta;
    return !(newPos1 > pos2 + size2 || newPos1 + size1 < pos2);
  }
}
