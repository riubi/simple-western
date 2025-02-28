import 'package:flame/components.dart';
import 'package:flutter/services.dart';

mixin Dismissible on Component, KeyboardHandler {
  void Function() get onDismiss => () => {};

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      onDismiss();
      removeFromParent();
    }
    return true;
  }
}
