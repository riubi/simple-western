import 'package:flutter/services.dart';
import 'package:simple_western/player_state.dart';

class PlayerKeySet {
  final LogicalKeyboardKey up;
  final LogicalKeyboardKey down;
  final LogicalKeyboardKey left;
  final LogicalKeyboardKey right;
  final LogicalKeyboardKey hit;
  final LogicalKeyboardKey shoot;

  late final Map<LogicalKeyboardKey, PlayerState> mapToState;

  PlayerKeySet(
    this.up,
    this.down,
    this.left,
    this.right,
    this.hit,
    this.shoot
  ) {
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
    return PlayerKeySet(
      LogicalKeyboardKey.keyW,
      LogicalKeyboardKey.keyS,
      LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.keyD,
      LogicalKeyboardKey.keyE,
      LogicalKeyboardKey.keyQ,
    );
  }

  static arrows() {
    return PlayerKeySet(
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
      LogicalKeyboardKey.shiftRight,
      LogicalKeyboardKey.controlRight,
    );
  }
}