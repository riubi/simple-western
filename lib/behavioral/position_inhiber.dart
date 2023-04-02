import 'dart:ui';
import 'package:flame/components.dart';

abstract class PositionInhiber {
  Offset inhib(PositionComponent movable, Offset positionDelta);
}