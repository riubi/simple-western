import 'package:flame/components.dart';

mixin PositionPrioritizable on PositionComponent {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    super.onLoad();
    updatePriority();
  }

  @override
  void update(double dt) {
    updatePriority();
  }

  void updatePriority() {
    priority = position.y as int;
  }
}
