import 'package:flutter/services.dart';
import 'package:simple_western/behavioral/object_state.dart';

class KeyBindingSet {
  final LogicalKeyboardKey up;
  final LogicalKeyboardKey down;
  final LogicalKeyboardKey left;
  final LogicalKeyboardKey right;
  final LogicalKeyboardKey hit;
  final LogicalKeyboardKey shoot;

  late final Map<LogicalKeyboardKey, ObjectState> mapToState;

  KeyBindingSet(
      this.up, this.down, this.left, this.right, this.hit, this.shoot) {
    mapToState = {
      up: ObjectState.up,
      down: ObjectState.down,
      left: ObjectState.left,
      right: ObjectState.right,
      hit: ObjectState.hit,
      shoot: ObjectState.shoot,
    };
  }

  static wasd() {
    return KeyBindingSet(
      LogicalKeyboardKey.keyW,
      LogicalKeyboardKey.keyS,
      LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.keyD,
      LogicalKeyboardKey.keyE,
      LogicalKeyboardKey.keyQ,
    );
  }

  static arrows() {
    return KeyBindingSet(
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
      LogicalKeyboardKey.enter,
      LogicalKeyboardKey.shiftRight,
    );
  }
}
