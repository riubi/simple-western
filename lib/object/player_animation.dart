import 'package:flame/components.dart';
import 'package:simple_western/object/player_state.dart';

class PlayerAnimation extends SpriteAnimationComponent with HasGameRef {
  static final defaultSize = Vector2.all(70);

  late SpriteAnimation going;
  late SpriteAnimation standing;
  late SpriteAnimation shooting;
  late SpriteAnimation dead;

  final String _asset;
  final String _deathAsset;
  final String _shootingAsset;

  bool get isBlocked =>
      _currentStates.contains(PlayerState.dead) ||
      (animation == shooting && !shooting.done());

  final Set<PlayerState> _currentStates;
  final Function()? _shootCallback;

  PlayerAnimation(Vector2 parentSize, this._currentStates, this._shootCallback,
      this._asset, this._shootingAsset, this._deathAsset)
      : super(size: defaultSize) {
    position.y = 6 + parentSize.y - size.y;
    position.x = parentSize.x / 2 - size.x / 2;
  }

  @override
  void onLoad() async {
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

    dead = await gameRef.loadSpriteAnimation(
        _deathAsset,
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2.all(192),
          stepTime: 0.20,
          loop: false,
        ));

    shooting = await gameRef.loadSpriteAnimation(
        _shootingAsset,
        SpriteAnimationData.sequenced(
          amount: 3,
          textureSize: Vector2.all(192),
          stepTime: 0.15,
          loop: false,
        ));

    shooting.onComplete = _shootCallback;
    animation = standing;

    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

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

    if (isBlocked || _currentStates.isEmpty) {
      return;
    }

    if (animation != shooting) {
      animation = standing;
    } else if (animation == shooting) {
      shooting.reset();
    }

    animation = going;
  }
}
