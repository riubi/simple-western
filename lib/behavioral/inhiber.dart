import 'dart:ui';

import 'package:flame/components.dart';

mixin Inhiber {
  Offset inhib(PositionComponent movable, Offset positionDelta);
}
