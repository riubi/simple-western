import 'package:flame/components.dart';

mixin Prioritized on PositionComponent {
  static const topPriority = 10000;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    updatePriority();
  }

  @override
  void update(double dt) {
    updatePriority();

    super.update(dt);
  }

  void updatePriority() {
    priority = topPriority + position.y.toInt() + size.y.toInt();
  }
}
