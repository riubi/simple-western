import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_western/audio_manager.dart';
import 'package:simple_western/damagable.dart';
import 'package:simple_western/global_config.dart';
import 'package:simple_western/player_state.dart';
import 'package:simple_western/position_inhiber.dart';
import 'package:simple_western/position_obstaclable.dart';
import 'package:simple_western/player_binging_set.dart';
import 'package:simple_western/bullet.dart';
import 'package:flame/rendering.dart';

class Player extends SpriteAnimationComponent
    with
        PositionObstaclable,
        Damagable,
        CollisionCallbacks,
        KeyboardHandler,
        HasGameRef {
  static final Vector2 defaultSize = Vector2.all(70);

  Set<PlayerState> _currentStates = {PlayerState.regular};

  final PlayerBindingSet _keySet;
  late Map _stateToMoveFunctionMap;

  bool get _isBlocked =>
      _currentStates.contains(PlayerState.dead) ||
      (animation == shooting && !shooting.done());

  final String _asset;
  final String _shootingAsset;
  final String _deathAsset;

  late final RectangleHitbox hitbox;

  final int _xSpeed = 2;
  final int _ySpeed = 1;

  late SpriteAnimation going;
  late SpriteAnimation standing;
  late SpriteAnimation shooting;
  late SpriteAnimation dead;

  Player(this._keySet, this._asset, this._shootingAsset, this._deathAsset)
      : super(size: defaultSize) {
    debugMode = GlobalConfig.debugMode;

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

    hp = 4;

    hitbox = RectangleHitbox(
        position: Vector2(size.x * 0.35, size.y * 0.48),
        size: Vector2(size.x * 0.3, size.y * 0.45));

    decorator.addLast(Shadow3DDecorator(
      base: Vector2(0, size.y * 0.89),
      angle: 2.2,
      blur: 0.4,
      opacity: 0.5,
    ));
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

    dead = await gameRef.loadSpriteAnimation(
        _deathAsset,
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2.all(192),
          stepTime: 0.20,
          loop: false,
        ));

    shooting.onComplete = () {
      shoot();
    };

    animation = standing;

    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _makeMoves();
  }

  void _makeMoves() {
    if (_currentStates.contains(PlayerState.dead)) {
      animation = dead;
      return;
    }

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
        .whereType<PositionInhiber>()
        .forEach((inhiber) => offset = inhiber.inhib(this, offset));

    if (offset != Offset.zero) {
      // @TODO порешать за логику анимации
      if (animation == shooting) {
        shooting.reset();
      }

      animation = going;
      position.x += offset.dx;
      position.y += offset.dy;
    }
  }

  // @TODO Прочекать коллизиии по коллбек методам методам.
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (!_currentStates.contains(PlayerState.dead)) {
      _currentStates = keysPressed
          .where((key) => _keySet.mapToState.containsKey(key))
          .map((key) => _keySet.mapToState[key]!)
          .toSet();
    }

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
    parent?.add(Bullet(position, anchor == Anchor.topLeft ? 1 : -1, this));
  }

  @override
  void onEliminating() {
    AudioManager.playAudio(AudioManager.manDeath);
    _currentStates = {PlayerState.dead};
    hitbox.size.y /= 2;
    hitbox.position.y += hitbox.size.y;
  }
}
