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
    var pos = gameRef.canvasSize * 0.45;
    for (var element in menus) {
      element.position = pos;
      pos.y += 40;
    }

    addAll(menus);

    return super.onLoad();
  }
}
