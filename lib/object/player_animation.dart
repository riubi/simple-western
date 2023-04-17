import 'package:flame/components.dart';
import 'package:simple_western/behavioral/object_state.dart';
import 'package:simple_western/config/player_animation_set.dart';

class PlayerAnimation extends SpriteAnimationComponent with HasGameRef {
  static final defaultSize = Vector2.all(70);

  late SpriteAnimation going;
  late SpriteAnimation standing;
  late SpriteAnimation shooting;
  late SpriteAnimation reloading;
  late SpriteAnimation dead;

  bool get isBlocked =>
      _currentStates.contains(ObjectState.dead) ||
      ((animation == shooting || animation == reloading) && !animation!.done());

  final PlayerAnimationSet _animationSet;
  final Set<ObjectState> _currentStates;
  final Function()? _preShootCallback;
  final Function()? _shootCallback;
  final Function() _reloadCallback;
  final Function() _deathCallback;

  PlayerAnimation(
      Vector2 parentSize,
      this._currentStates,
      this._preShootCallback,
      this._shootCallback,
      this._reloadCallback,
      this._deathCallback,
      this._animationSet)
      : super(size: defaultSize) {
    position
      ..y = 6 + parentSize.y - size.y
      ..x = parentSize.x / 2 - size.x / 2;
  }

  @override
  void onLoad() async {
    standing = await gameRef.loadSpriteAnimation(
        _animationSet.standingData,
        SpriteAnimationData.sequenced(
          amount: 2,
          textureSize: _animationSet.size,
          stepTime: 0.30,
          loop: true,
        ));

    going = await gameRef.loadSpriteAnimation(
        _animationSet.goingData,
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: _animationSet.size,
          stepTime: 0.15,
          loop: true,
        ));

    dead = await gameRef.loadSpriteAnimation(
        _animationSet.deathData,
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: _animationSet.size,
          stepTime: 0.20,
          loop: false,
        ))
      ..onComplete = _deathCallback;

    shooting = await gameRef.loadSpriteAnimation(
        _animationSet.shootingData,
        SpriteAnimationData.sequenced(
          amount: 3,
          textureSize: _animationSet.size,
          stepTime: 0.15,
          loop: false,
        ))
      ..onComplete = _shootCallback
      ..onStart = _preShootCallback;

    reloading = await gameRef.loadSpriteAnimation(
        _animationSet.reloadData,
        SpriteAnimationData.sequenced(
          amount: 2,
          textureSize: _animationSet.size,
          stepTime: 0.15,
          loop: false,
        ))
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
}
