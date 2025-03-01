import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GradientBackground extends PositionComponent {
  final Color _from;
  final Color _to;

  GradientBackground(this._from, this._to);

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        _from,
        _to,
      ],
    );

    final paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawRect(rect, paint);
  }
}
