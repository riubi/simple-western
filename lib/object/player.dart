import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:simple_western/behavioral/prioritizable.dart';
import 'package:simple_western/behavioral/inhiber.dart';
import 'package:simple_western/behavioral/obstaclable.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/config/player_binging_set.dart';
import 'package:simple_western/config/global_config.dart';
import 'package:simple_western/behavioral/damagable.dart';
import 'package:simple_western/object/player_animation.dart';
import 'package:simple_western/object/player_state.dart';
import 'package:simple_western/object/bullet.dart';
import 'package:flame/rendering.dart';

class Player extends PositionComponent
    with
        Obstaclable,
        Prioritizable,
        Damagable,
        CollisionCallbacks,
        KeyboardHandler,
        HasGameRef {
  static const int _xSpeed = 2;
  static const int _ySpeed = 1;

  static final Vector2 _defaultSize = Vector2.all(70);
  static final Map _stateToMoveFunctionMap = {
    PlayerState.up: (Offset offset) => Offset(offset.dx, offset.dy - _ySpeed),
    PlayerState.down: (Offset offset) => Offset(offset.dx, offset.dy + _ySpeed),
    PlayerState.left: (Offset offset) => Offset(offset.dx - _xSpeed, offset.dy),
    PlayerState.right: (Offset offset) =>
        Offset(offset.dx + _xSpeed, offset.dy),
  };

  final Set<PlayerState> _currentStates = {PlayerState.regular};

  final PlayerBindingSet _keySet;

  late final PlayerAnimation sprite;
  late final RectangleHitbox hitbox;

  Player(this._keySet, _asset, _shootingAsset, _deathAsset)
      : super(size: _defaultSize) {
    debugMode = GlobalConfig.debugMode;

    hp = GlobalConfig.playerHP;

    hitbox = RectangleHitbox(
        position: Vector2(size.x * 0.35, size.y * 0.48),
        size: Vector2(size.x * 0.3, size.y * 0.45));

    decorator.addLast(Shadow3DDecorator(
      base: Vector2(0, size.y * 0.89),
      angle: 2.2,
      blur: 0.4,
      opacity: 0.5,
    ));

    sprite = PlayerAnimation(
        _currentStates, shoot, _asset, _shootingAsset, _deathAsset);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(sprite);
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_currentStates.contains(PlayerState.dead)) {
      return;
    }

    if (sprite.isBlocked || _currentStates.isEmpty) {
      return;
    }

    Offset offset = Offset.zero;

    _currentStates
        .where((state) => _stateToMoveFunctionMap.containsKey(state))
        .forEach((state) => offset = _stateToMoveFunctionMap[state]!(offset));

    if (offset.dx > 0) {
      turnRight();
    } else if (offset.dx < 0) {
      turnLeft();
    }

    activeCollisions
        .whereType<Inhiber>()
        .forEach((inhiber) => offset = inhiber.inhib(this, offset));

    if (offset != Offset.zero) {
      position.x += offset.dx;
      position.y += offset.dy;
    }
  }

  // @TODO Прочекать коллизиии по коллбек методам методам.
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (!_currentStates.contains(PlayerState.dead)) {
      _currentStates.clear();
      _currentStates.addAll(keysPressed
          .where((key) => _keySet.mapToState.containsKey(key))
          .map((key) => _keySet.mapToState[key]!)
          .toSet());
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
    super.onEliminating();

    AudioSet.playAudio(AudioSet.manDeath);
    _currentStates.clear();
    _currentStates.add(PlayerState.dead);

    hitbox.size.y /= 2;
    hitbox.position.y += hitbox.size.y;
  }
}
