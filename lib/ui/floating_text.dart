import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:simple_western/ui/text_builder.dart';

class FloatingText extends PositionComponent {
  static const _fadeOutTime = 1.4;
  static const _riseSpeed = 10.0;
  static const _topPadding = 15;

  final String text;
  final TextPaint textPaint;

  FloatingText(this.text, Vector2 position)
      : textPaint = TextPaint(
            style: TextBuilder.buildStyle(false,
                fontSize: 14, letterSpacing: 0, lineHeight: 1, height: 1)),
        super(position: position, anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position.y -= _topPadding;

    add(TimerComponent(
      period: _fadeOutTime,
      onTick: () => removeFromParent(),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= _riseSpeed * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPaint.render(canvas, text, Vector2.zero(), anchor: Anchor.center);
  }
}
