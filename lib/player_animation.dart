import 'package:flame/components.dart';
import 'package:simple_western/player.dart';
import 'package:simple_western/player_state.dart';

class PlayerAnimation extends SpriteAnimationComponent with HasGameRef {
  static final Vector2 defaultSize = Vector2.all(70);

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

  PlayerAnimation(
      this._currentStates, this._asset, this._shootingAsset, this._deathAsset)
      : super(size: defaultSize);

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
      if (parent is Player) {
        Player player = parent as Player;
        player.shoot();
      }
    };

    animation = standing;
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
