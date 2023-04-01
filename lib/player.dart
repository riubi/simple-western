import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:simple_western/global_config.dart';
import 'package:simple_western/player_state.dart';
import 'package:simple_western/position_bordarable.dart';
import 'package:simple_western/position_obstaclable.dart';
import 'package:simple_western/player_binging_set.dart';
import 'package:simple_western/gun_bullet.dart';

class Player extends SpriteAnimationComponent
    with PositionObstaclable, CollisionCallbacks, KeyboardHandler, HasGameRef {
  static final Vector2 defaultSize = Vector2.all(70);

  Set<PlayerState> _currentStates = {PlayerState.regular};

  final PlayerBindingSet _keySet;
  late Map _stateToMoveFunctionMap;

  bool get _isBlocked => animation == shooting && !shooting.done();

  final String _asset;
  final String _shootingAsset;

  final int _xSpeed = 2;
  final int _ySpeed = 1;

  late SpriteAnimation going;
  late SpriteAnimation standing;
  late SpriteAnimation shooting;

  Player(this._keySet, this._asset, this._shootingAsset)
      : super(size: defaultSize) {
    _stateToMoveFunctionMap = {
      PlayerState.up: (Offset offset) => Offset(offset.dx, offset.dy - _ySpeed),
      PlayerState.down: (Offset offset) =>
          Offset(offset.dx, offset.dy + _ySpeed),
      PlayerState.left: (Offset offset) {
        turnLeft();
        return Offset(offset.dx - _xSpeed, offset.dy);
      },
      PlayerState.right: (Offset offset) {
        turnRight();
        return Offset(offset.dx + _xSpeed, offset.dy);
      },
    };

    debugMode = GlobalConfig.debugMode;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    going = await gameRef.loadSpriteAnimation(
        _asset,
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2.all(192),
          stepTime: 0.15,
          loop: true,
        ));

    standing = await gameRef.loadSpriteAnimation(
        _asset,
        SpriteAnimationData.sequenced(
          amount: 2,
          textureSize: Vector2.all(192),
          stepTime: 0.3,
          loop: true,
        ));

    shooting = await gameRef.loadSpriteAnimation(
        _shootingAsset,
        SpriteAnimationData.sequenced(
          amount: 3,
          textureSize: Vector2.all(192),
          stepTime: 0.15,
          loop: false,
        ));

    shooting.onComplete = () {
      shoot();
    };

    animation = standing;

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    _makeMoves();
  }

  void _makeMoves() {
    if (_currentStates.contains(PlayerState.shoot)) {
      animation = shooting;
      if (shooting.done()) {
        shooting.reset();
        shooting.currentIndex = 1;
      }
    }

    if (_isBlocked || _currentStates.isEmpty) {
      return;
    }

    if (animation != shooting) {
      animation = standing;
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

    if (offset != Offset.zero) {
      if (animation == shooting) {
        shooting.reset();
      }

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

  void shoot() {
    // TODO: привязать выстрел к сцене от игрока
    // TODO: добавить урон
    final bullet = GunBullet(position, anchor == Anchor.topLeft ? 1 : -1);
    parent?.add(bullet);
    print('SHOOT!');
  }
}
