import 'package:flutter/services.dart';
import 'package:simple_western/behavioral/object_state.dart';

class KeyBindingSet {
  final Map<PhysicalKeyboardKey, ObjectState> mapToState;

  KeyBindingSet(this.mapToState);

  static KeyBindingSet bot() {
    return KeyBindingSet({});
  }

  static KeyBindingSet wasd() {
    return KeyBindingSet({
      PhysicalKeyboardKey.keyW: ObjectState.up,
      PhysicalKeyboardKey.keyS: ObjectState.down,
      PhysicalKeyboardKey.keyA: ObjectState.left,
      PhysicalKeyboardKey.keyD: ObjectState.right,
      PhysicalKeyboardKey.keyE: ObjectState.reload,
      PhysicalKeyboardKey.keyQ: ObjectState.shoot,
    });
  }

  static KeyBindingSet arrows() {
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
