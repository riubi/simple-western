import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:simple_western/behavioral/object_state.dart';
import 'package:simple_western/behavioral/shadowable.dart';
import 'package:simple_western/config/player_animation_set.dart';

class PlayerAnimation extends SpriteAnimationComponent
    with HasGameRef, Shadowable {
  static const _bottomPositionOffset = 6;
  static final defaultSize = Vector2.all(70);

  late SpriteAnimation going;
  late SpriteAnimation standing;
  late SpriteAnimation shooting;
  late SpriteAnimation reloading;
  late SpriteAnimation death;
  late SpriteAnimationTicker shootingTicker;

  bool get isBlocked =>
      _currentStates.contains(ObjectState.dead) ||
      ((animation == shooting || animation == reloading) &&
          !(animationTicker?.done() ?? true));

  final PlayerAnimationSet _set;
  final Set<ObjectState> _currentStates;
  final void Function()? _preShootCallback;
  final void Function()? _shootCallback;
  final void Function() _reloadCallback;

  PlayerAnimation(
      Vector2 parentSize,
      this._currentStates,
      this._preShootCallback,
      this._shootCallback,
      this._reloadCallback,
      this._set)
      : super(size: defaultSize) {
    position
      ..y = _bottomPositionOffset + parentSize.y - size.y
      ..x = parentSize.x / 2 - size.x / 2;

    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    standing = await _loadSprite(_set.standingData);
    going = await _loadSprite(_set.goingData);
    death = await _loadSprite(_set.deathData);
    shooting = await _loadSprite(_set.shootingData);
    reloading = await _loadSprite(_set.reloadData);

    animation = standing;

    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    updatePlayerAnimationBasedOnState();
  }

  void updatePlayerAnimationBasedOnState() {
    if (_isPlayerDead()) {
      return _death();
    }

    if (_isPlayerReloading()) {
      return _reloading();
    }

    if (_isPlayerShooting()) {
      return _handleShooting();
    }

    if (_isPlayerBlockedOrNoCurrentStates()) {
      _standing();
    } else {
      _going();
    }
  }

  void _handleShooting() {
    if (animation != shooting) {
      animation = shooting;
      animationTicker?.onComplete = _shootCallback;
      // ..onStart = _preShootCallback;
    }
    if (animationTicker!.done()) {
      animationTicker
        ?..reset()
        ..currentIndex = 1;
    }
  }

  void _death() {
    if (animation != death) {
      animation = death;
    }
  }

  void _going() {
    animation = going;
  }

  void _standing() {
    if (animation != shooting) {
      animation = standing;
    }
  }

  void _reloading() {
    if (animation != reloading) {
      animation = reloading;
      animationTicker?.onStart = _reloadCallback;
    }
    if (animationTicker!.done()) {
      animationTicker
        ?..reset()
        ..currentIndex = 1;
    }
  }

  bool _isPlayerDead() => _currentStates.contains(ObjectState.dead);

  bool _isPlayerShooting() => _currentStates.contains(ObjectState.shoot);

  bool _isPlayerReloading() => _currentStates.contains(ObjectState.reload);

  bool _isPlayerBlockedOrNoCurrentStates() =>
      isBlocked || _currentStates.isEmpty;

  Future<SpriteAnimation> _loadSprite(
          (String, SpriteAnimationData) spriteData) =>
      gameRef.loadSpriteAnimation(spriteData.$1, spriteData.$2);
}
