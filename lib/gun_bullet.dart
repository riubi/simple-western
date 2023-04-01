import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/global_config.dart';

class GunBullet extends PositionComponent with CollisionCallbacks {
  int _directionModifier = 1;

  GunBullet(position, this._directionModifier) {
    this.position = position;
    debugMode = GlobalConfig.debugMode;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position.y += 46;
    if (_directionModifier > 0) {
      position.x += 72;
    } else {
      anchor = Anchor.topRight;
      position.x += 3;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.x += 5 * _directionModifier;
    // TODO: Ликвидировать обьект по окончанию.
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color.fromARGB(255, 0, 0, 0);
    const rect = Rect.fromLTWH(0, 0, 6, 6);
    canvas.drawRect(rect, paint);
  }
}
