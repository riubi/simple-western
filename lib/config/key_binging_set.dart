import 'package:flutter/services.dart';
import 'package:simple_western/behavioral/object_state.dart';

class KeyBindingSet {
  final Map<PhysicalKeyboardKey, ObjectState> mapToState;

  KeyBindingSet(this.mapToState);

  static bot() {
    return KeyBindingSet({});
  }

  static wasd() {
    return KeyBindingSet({
      PhysicalKeyboardKey.keyW: ObjectState.up,
      PhysicalKeyboardKey.keyS: ObjectState.down,
      PhysicalKeyboardKey.keyA: ObjectState.left,
      PhysicalKeyboardKey.keyD: ObjectState.right,
      PhysicalKeyboardKey.keyE: ObjectState.reload,
      PhysicalKeyboardKey.keyQ: ObjectState.shoot,
    });
  }

  static arrows() {
    return KeyBindingSet({
      PhysicalKeyboardKey.arrowUp: ObjectState.up,
      PhysicalKeyboardKey.arrowDown: ObjectState.down,
      PhysicalKeyboardKey.arrowLeft: ObjectState.left,
      PhysicalKeyboardKey.arrowRight: ObjectState.right,
      PhysicalKeyboardKey.enter: ObjectState.reload,
      PhysicalKeyboardKey.shiftRight: ObjectState.shoot,
    });
  }
}
