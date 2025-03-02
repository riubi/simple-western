import 'dart:ui';

import 'package:flame/components.dart';

class PaintedBackground extends RectangleComponent {
  PaintedBackground(Color color)
      : super(
          paint: Paint()..color = color,
          anchor: Anchor.bottomCenter,
        );
}
