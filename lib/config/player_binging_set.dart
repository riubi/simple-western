import 'package:flutter/services.dart';
import 'package:simple_western/object/player_state.dart';

class PlayerBindingSet {
  final LogicalKeyboardKey up;
  final LogicalKeyboardKey down;
  final LogicalKeyboardKey left;
  final LogicalKeyboardKey right;
  final LogicalKeyboardKey hit;
  final LogicalKeyboardKey shoot;

  late final Map<LogicalKeyboardKey, PlayerState> mapToState;

  PlayerBindingSet(this.up, this.down, this.left, this.right, this.hit, this.shoot) {
    mapToState = {
      up: PlayerState.up,
      down: PlayerState.down,
      left: PlayerState.left,
      right: PlayerState.right,
      hit: PlayerState.hit,
      shoot: PlayerState.shoot,
    };
  }

  static wasd() {
    return PlayerBindingSet(
      LogicalKeyboardKey.keyW,
      LogicalKeyboardKey.keyS,
      LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.keyD,
      LogicalKeyboardKey.keyE,
      LogicalKeyboardKey.keyQ,
    );
  }

  static arrows() {
    return PlayerBindingSet(
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
      LogicalKeyboardKey.enter,
      LogicalKeyboardKey.shiftRight,
    );
  }
}
