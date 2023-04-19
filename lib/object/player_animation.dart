import 'package:flame/components.dart';
import 'package:simple_western/behavioral/object_state.dart';
import 'package:simple_western/config/player_animation_set.dart';

class PlayerAnimation extends SpriteAnimationComponent with HasGameRef {
  static const _bottomPositionOffset = 6;
  static final defaultSize = Vector2.all(70);

  late SpriteAnimation going;
  late SpriteAnimation standing;
  late SpriteAnimation shooting;
  late SpriteAnimation reloading;
  late SpriteAnimation dead;

  bool get isBlocked =>
      _currentStates.contains(ObjectState.dead) ||
      ((animation == shooting || animation == reloading) && !animation!.done());

  final PlayerAnimationSet _set;
  final Set<ObjectState> _currentStates;
  final void Function()? _preShootCallback;
  final void Function()? _shootCallback;
  final void Function() _reloadCallback;
  final void Function() _deathCallback;

  PlayerAnimation(
      Vector2 parentSize,
      this._currentStates,
      this._preShootCallback,
      this._shootCallback,
      this._reloadCallback,
      this._deathCallback,
      this._set)
      : super(size: defaultSize) {
    position
      ..y = _bottomPositionOffset + parentSize.y - size.y
      ..x = parentSize.x / 2 - size.x / 2;
  }

  @override
  void onLoad() async {
    standing = await _loadSprite(_set.standingData);

    going = await _loadSprite(_set.goingData);

    dead = await _loadSprite(_set.deathData)
      ..onComplete = _deathCallback;

    shooting = await _loadSprite(_set.shootingData)
      ..onComplete = _shootCallback
      ..onStart = _preShootCallback;

    reloading = await _loadSprite(_set.reloadData)
      ..onComplete = _reloadCallback;

    animation = standing;

    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    updatePlayerAnimationBasedOnState();
  }

  void updatePlayerAnimationBasedOnState() {
    if (_isPlayerDead()) {
      animation = dead;
    } else if (_isPlayerReloading()) {
      if (animation != reloading) {
        animation = reloading;
      }
      if (reloading.done()) {
        reloading
          ..reset()
          ..currentIndex = 1;
      }
    } else if (_isPlayerShooting()) {
      if (animation != shooting) {
        animation = shooting;
      }
      if (shooting.done()) {
        shooting
          ..reset()
          ..currentIndex = 1;
      }
    } else if (_isPlayerBlockedOrNoCurrentStates()) {
      if (animation != shooting) {
        animation = standing;
      }
    } else {
      if (animation == shooting) {
        shooting.reset();
      }
      animation = going;
    }
  }

  bool _isPlayerDead() {
    return _currentStates.contains(ObjectState.dead);
  }

  bool _isPlayerShooting() {
    return _currentStates.contains(ObjectState.shoot);
  }

  bool _isPlayerReloading() {
    return _currentStates.contains(ObjectState.reload);
  }

  bool _isPlayerBlockedOrNoCurrentStates() {
    return isBlocked || _currentStates.isEmpty;
  }

  Future<SpriteAnimation> _loadSprite((String, SpriteAnimationData) spriteData) =>
      gameRef.loadSpriteAnimation(spriteData.$0, spriteData.$1);
}
