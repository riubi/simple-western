import 'package:flame/components.dart';
import 'package:flame/rendering.dart';

mixin Shadowable on PositionComponent {
  static const sizeFactor = 0.89;
  static const shadowAngle = 2.2;
  static const shadowOpacity = 0.25;

  @override
  Future<void> onLoad() async {
    decorator.addLast(Shadow3DDecorator(
      base: Vector2(0, size.y * sizeFactor),
      angle: shadowAngle,
      blur: 1,
      opacity: shadowOpacity,
    ));

    await super.onLoad();
  }
}
