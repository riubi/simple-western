import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:simple_western/global_config.dart';
import 'package:simple_western/player_state.dart';
import 'package:simple_western/position_bordarable.dart';
import 'package:simple_western/position_obstaclable.dart';
import 'package:simple_western/player_key_set.dart';

class Player extends SpriteAnimationComponent with PositionObstaclable, CollisionCallbacks, KeyboardHandler, HasGameRef {

  static final Vector2 defaultSize = Vector2.all(70);

  Set<PlayerState> _currentStates = {PlayerState.regular};

  final PlayerKeySet _keySet;
  late Map _stateToMoveFunctionMap;

  final String _asset;

  final int _xSpeed = 2;
  final int _ySpeed = 1;

  late SpriteAnimation going;
  late SpriteAnimation standing;

  Player(this._keySet, this._asset) : super(size: defaultSize) {
    _stateToMoveFunctionMap = {
      PlayerState.up: (Offset offset) => Offset(offset.dx, offset.dy-_ySpeed),
      PlayerState.down: (Offset offset) => Offset(offset.dx, offset.dy+_ySpeed),
      PlayerState.left: (Offset offset) {
        turnLeft();
        return Offset(offset.dx-_xSpeed, offset.dy);
      },
      PlayerState.right: (Offset offset) {
        turnRight();
        return Offset(offset.dx+_xSpeed, offset.dy);
      },
    };

    debugMode = GlobalConfig.debugMode;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    going = (await gameRef.loadSpriteAnimation(_asset, SpriteAnimationData.sequenced(
      amount: 4,
      textureSize: Vector2.all(192),
      stepTime: 0.15,
      loop: true,
    )));

    standing = (await gameRef.loadSpriteAnimation(_asset, SpriteAnimationData.sequenced(
      amount: 1,
      textureSize: Vector2.all(192),
      stepTime: 1,
      loop: false,
    )));

    animation = standing;

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    _makeMoves();
  }

  void _makeMoves() {
    animation = standing;
    if (_currentStates.isEmpty) {
      return;
    }

    Offset offset = Offset.zero;
    
    _currentStates
      .where((state) => _stateToMoveFunctionMap.containsKey(state))
      .forEach((state) => offset = _stateToMoveFunctionMap[state]!(offset));

    activeCollisions
        .whereType<PositionObstaclable>()
        .forEach((obstaclable) => offset = obstaclable.inhib(this, offset));

    activeCollisions
        .whereType<PositionBordarable>()
        .forEach((border) => offset = border.inhib(this, offset));

    if (offset != Offset.zero){
      animation = going;
      position.x += offset.dx;
      position.y += offset.dy;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _currentStates = keysPressed
      .where((key) => _keySet.mapToState.containsKey(key))
      .map((key) => _keySet.mapToState[key]!)
      .toSet();

    return true;
  }

  void turnLeft() {
    if (anchor == Anchor.topLeft) {
      flipHorizontallyAroundCenter();
      anchor = Anchor.topRight;
      position.x -= size.x;
    }
  }

  void turnRight() {
    if (anchor == Anchor.topRight) {
      flipHorizontallyAroundCenter();
      anchor = Anchor.topLeft;
      position.x -= size.x;
    }
  }
}