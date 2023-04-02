import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/audio_manager.dart';
import 'package:simple_western/global_config.dart';
import 'package:simple_western/behavioral/position_obstaclable.dart';

import 'damagable.dart';

class Bullet extends PositionComponent with CollisionCallbacks {
  final double _directionModifier;
  final int _strength = 1;
  final int _bulletSpeed = 7;
  late int _distance;

  static final Paint paint = Paint()
    ..color = const Color.fromARGB(255, 0, 0, 0);
  static final Paint paint1 = Paint()
    ..color = const Color.fromARGB(255, 255, 212, 144);

  late Rect rect;
  late Rect rect1;

  final PositionComponent owner;

  Bullet(position, this._directionModifier, this.owner) {
    this.position = position;
    size = Vector2(5, 3);
    debugMode = GlobalConfig.debugMode;
    if (_directionModifier < 0) {
      anchor = Anchor.topRight;
    }

    _distance = Random().nextInt(250) + 400;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // @TODO move position to player control.
    position.y += 46;
    if (_directionModifier > 0) {
      position.x += 72;
    } else {
      position.x += 3;
    }

    if (_directionModifier > 0) {
      rect = const Rect.fromLTWH(0, 0, 5, 3);
      rect1 = const Rect.fromLTWH(-28, 0, 28, 3);
    } else {
      rect = const Rect.fromLTWH(0, 0, 5, 3);
      rect1 = const Rect.fromLTWH(5, 0, 28, 3);
    }

    AudioManager.playBulletShot();
    add(RectangleHitbox(size: Vector2.all(10)));
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (owner == other) {
      return;
    }

    if (other is Damagable) {
      AudioManager.playAudio(AudioManager.bulletDelivery);
      other.damage(_strength);
    }

    if (other is PositionObstaclable) {
      parent?.remove(this);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.x += _bulletSpeed * _directionModifier;
    _distance -= _bulletSpeed;
    if (_distance < 0) {
      parent?.remove(this);
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(rect1, paint1);
    canvas.drawRect(rect, paint);
  }
}
