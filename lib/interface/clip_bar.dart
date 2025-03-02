import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:simple_western/entity/gun.dart';

class ClipBar extends PositionComponent {
  static const double bulletWidth = 4;
  static const double bulletHeight = 3;
  static const double bulletSpacing = 2;

  final Gun gun;
  final List<RectangleComponent> _bullets = [];

  ClipBar(this.gun) : super() {
    gun.addClipHandler(_onClipUpdate);
  }

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < gun.bulletCounts; i++) {
      var bullet = RectangleComponent(
        size: Vector2(bulletWidth, bulletHeight),
        paint: BasicPalette.yellow.paint(),
        anchor: Anchor.topCenter,
        position: Vector2(i * (bulletWidth + bulletSpacing), 0),
      );

      _bullets.add(bullet);
      add(bullet);
    }

    await super.onLoad();
  }

  void _onClipUpdate(int clipSize) {
    for (int i = 0; i < _bullets.length; i++) {
      _bullets[i].opacity = i < clipSize ? 1.0 : 0.2;
    }
  }
}
