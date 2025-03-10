import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:simple_western/behavioral/inhiber.dart';
import 'package:simple_western/behavioral/object_state.dart';
import 'package:simple_western/config/key_binging_set.dart';

mixin Controllable on PositionComponent
    implements CollisionCallbacks, KeyboardHandler {
  final Set<ObjectState> currentStates = {};

  late final Map<ObjectState, Offset Function(Offset)> _stateToMoveFunctionMap;
  late final bool Function() _isBlocked;
  late final KeyBindingSet _keySet;
  late final int _xSpeed;
  late final int _ySpeed;

  PositionComponent get animation;

  void initControl(
      int xSpeed, int ySpeed, KeyBindingSet keySet, bool Function() isBlocked) {
    _xSpeed = xSpeed;
    _ySpeed = ySpeed;
    _keySet = keySet;
    _isBlocked = isBlocked;

    _stateToMoveFunctionMap = {
      ObjectState.up: (Offset offset) => Offset(offset.dx, offset.dy - _ySpeed),
      ObjectState.down: (Offset offset) =>
          Offset(offset.dx, offset.dy + _ySpeed),
      ObjectState.left: (Offset offset) =>
          Offset(offset.dx - _xSpeed, offset.dy),
      ObjectState.right: (Offset offset) =>
          Offset(offset.dx + _xSpeed, offset.dy),
    };
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isDeadOrBlocked()) {
      return;
    }

    Offset offset = _calculateOffset();

    offset *= dt;

    _updateDirection(offset);

    offset = _applyInhiberEffect(offset);

    _updatePosition(offset);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (_keySet.mapToState.containsKey(event.physicalKey)) {
      if (event is KeyUpEvent) {
        currentStates.remove(_keySet.mapToState[event.physicalKey]!);
      } else if (event is KeyDownEvent) {
        currentStates.add(_keySet.mapToState[event.physicalKey]!);
      }
    }
    return true;
  }

  void dead() {
    currentStates
      ..clear()
      ..add(ObjectState.dead);
  }

  bool isTurnLeft() => animation.anchor.x == Anchor.topRight.x;

  bool isTurnRight() => animation.anchor.x == Anchor.topLeft.x;

  void turnLeft() {
    if (!isTurnLeft()) {
      animation.flipHorizontallyAroundCenter();
      animation.anchor = Anchor.topRight;
      animation.position.x -= animation.size.x;
    }
  }

  void turnRight() {
    if (!isTurnRight()) {
      animation.flipHorizontallyAroundCenter();
      animation.anchor = Anchor.topLeft;
      animation.position.x -= animation.size.x;
    }
  }

  bool _isDeadOrBlocked() {
    return currentStates.contains(ObjectState.dead) ||
        currentStates.isEmpty ||
        _isBlocked();
  }

  Offset _calculateOffset() {
    Offset offset = Offset.zero;

    currentStates
        .where((state) => _stateToMoveFunctionMap.containsKey(state))
        .forEach((state) => offset = _stateToMoveFunctionMap[state]!(offset));

    return offset;
  }

  void _updateDirection(Offset offset) {
    if (offset.dx > 0) {
      turnRight();
    } else if (offset.dx < 0) {
      turnLeft();
    }
  }

  Offset _applyInhiberEffect(Offset offset) {
    if (isColliding) {
      activeCollisions
          .whereType<Inhiber>()
          .forEach((inhiber) => offset = inhiber.inhib(this, offset));
    }

    return offset;
  }

  void _updatePosition(Offset offset) {
    if (offset != Offset.zero) {
      position
        ..x += offset.dx
        ..y += offset.dy;
    }
  }
}
