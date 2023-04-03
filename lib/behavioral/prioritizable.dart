import 'package:flame/components.dart';

mixin Prioritizable on PositionComponent {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    super.onLoad();
    updatePriority();
  }

  @override
  void update(double dt) {
    updatePriority();

    super.update(dt);
  }

  void updatePriority() {
    priority = 10000 + position.y.toInt() + size.y.toInt();
  }
}
