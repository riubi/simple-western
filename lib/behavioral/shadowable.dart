import 'package:flame/components.dart';
import 'package:flame/rendering.dart';

mixin Shadowable on PositionComponent {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    decorator.addLast(Shadow3DDecorator(
      base: Vector2(0, size.y * 0.89),
      angle: 2.2,
      blur: 0.4,
      opacity: 0.5,
    ));
  }
}
