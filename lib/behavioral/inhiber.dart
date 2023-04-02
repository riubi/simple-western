import 'dart:ui';
import 'package:flame/components.dart';

abstract class Inhiber {
  Offset inhib(PositionComponent movable, Offset positionDelta);
}
