import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:simple_western/global_config.dart';

class GunBullet extends PositionComponent with CollisionCallbacks {
  final int _directionModifier;

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

    FlameAudio.playLongAudio('gunshot-1.mp3', volume: 1);
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    print(other);
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    print(other);
    super.onCollisionStart(intersectionPoints, other);
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
