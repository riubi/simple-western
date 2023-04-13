import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:simple_western/behavioral/inhiber.dart';
import 'package:simple_western/behavioral/object_state.dart';
import 'package:simple_western/config/key_binging_set.dart';

mixin Controlable on PositionComponent
    implements CollisionCallbacks, KeyboardHandler {
  final Set<ObjectState> currentStates = {};

  late final Map<ObjectState, Function(Offset)> _stateToMoveFunctionMap;
  late final Function() _isBlock;
  late final KeyBindingSet _keySet;
  late final int _xSpeed;
  late final int _ySpeed;

  initControl(xSpeed, ySpeed, KeyBindingSet keySet, Function() isBlockCheck) {
    _xSpeed = xSpeed;
    _ySpeed = ySpeed;
    _keySet = keySet;
    _isBlock = isBlockCheck;

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
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (_keySet.mapToState.containsKey(event.physicalKey)) {
      switch (event.runtimeType) {
        case RawKeyUpEvent:
          currentStates.remove(_keySet.mapToState[event.physicalKey]!);
          break;
        case RawKeyDownEvent:
          currentStates.add(_keySet.mapToState[event.physicalKey]!);
          break;
      }
    }

    return true;
  }

  void dead() {
    currentStates
      ..clear()
      ..add(ObjectState.dead);
  }

  void turnLeft() {
    if (anchor.x == Anchor.centerLeft.x) {
      flipHorizontallyAroundCenter();
      anchor = Anchor.topRight;
      position.x -= size.x;
    }
  }

  void turnRight() {
    if (anchor.x == Anchor.centerRight.x) {
      flipHorizontallyAroundCenter();
      anchor = Anchor.topLeft;
      position.x -= size.x;
    }
  }

  bool _isDeadOrBlocked() {
    return currentStates.contains(ObjectState.dead) ||
        currentStates.isEmpty ||
        _isBlock();
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
