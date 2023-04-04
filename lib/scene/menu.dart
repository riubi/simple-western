import 'dart:async';

import 'package:flame/components.dart';
import 'package:simple_western/ui/menu_element.dart';

class Menu extends Component with HasGameRef {
  final List<MenuElement> menus = [];

  Menu(Function() startCallback) {
    menus.add(MenuElement("Start", startCallback));
  }

  @override
  FutureOr<void> onLoad() {
    resize(gameRef.canvasSize);

    addAll(menus);

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    resize(size);
    super.onGameResize(size);
  }

  void resize(Vector2 size) {
    var pos = size * 0.45;
    for (var element in menus) {
      element.position = pos;
      pos.y += 40;
    }
  }
}
