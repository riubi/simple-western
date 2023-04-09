import 'package:flutter/services.dart';
import 'package:simple_western/behavioral/object_state.dart';

class KeyBindingSet {
  final Map<LogicalKeyboardKey, ObjectState> mapToState;

  KeyBindingSet(this.mapToState);

  static bot() {
    return KeyBindingSet({});
  }

  static wasd() {
    return KeyBindingSet({
      LogicalKeyboardKey.keyW: ObjectState.up,
      LogicalKeyboardKey.keyS: ObjectState.down,
      LogicalKeyboardKey.keyA: ObjectState.left,
      LogicalKeyboardKey.keyD: ObjectState.right,
      LogicalKeyboardKey.keyE: ObjectState.hit,
      LogicalKeyboardKey.keyQ: ObjectState.shoot,
    });
  }

  static arrows() {
    return KeyBindingSet({
      LogicalKeyboardKey.arrowUp: ObjectState.up,
      LogicalKeyboardKey.arrowDown: ObjectState.down,
      LogicalKeyboardKey.arrowLeft: ObjectState.left,
      LogicalKeyboardKey.arrowRight: ObjectState.right,
      LogicalKeyboardKey.enter: ObjectState.hit,
      LogicalKeyboardKey.shiftRight: ObjectState.shoot,
    });
  }
}
