import 'package:flame/components.dart';
import 'package:simple_western/object/gun.dart';

class ClipBar extends TextComponent {
  ClipBar(Gun gun, Vector2 position, Anchor anchor)
      : super(position: position, anchor: anchor) {
    text = gun.bulletCounts.toString();
    gun.addClipHandler(_onClipUpdate);
  }

  void _onClipUpdate(int slipSize) {
    text = slipSize.toString();
  }
}
