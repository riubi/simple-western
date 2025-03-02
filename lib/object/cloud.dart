import 'package:flame/components.dart';

class Cloud extends SpriteComponent with HasGameRef {
  final double speed;

  Cloud(this.speed, Sprite sprite, Vector2 position)
      : super(sprite: sprite, position: position, anchor: Anchor.bottomCenter);

  @override
  void update(double dt) {
    position.x += speed * dt;

    if (position.x > gameRef.canvasSize.x) {
      removeFromParent();
    }

    super.update(dt);
  }
}
