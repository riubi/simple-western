import 'package:flame/components.dart';

class PlayerAnimationSet {
  static final Vector2 size = Vector2.all(192);

  final (String, SpriteAnimationData) standingData;
  final (String, SpriteAnimationData) goingData;
  final (String, SpriteAnimationData) deathData;
  final (String, SpriteAnimationData) shootingData;
  final (String, SpriteAnimationData) reloadData;

  PlayerAnimationSet({
    required this.standingData, 
    required this.goingData,
    required this.deathData,
    required this.shootingData,
    required this.reloadData, 
  });

  static PlayerAnimationSet firstSkin() => _defSkin(
    'fighters/player-1.png',
    'fighters/player-1-going.png',
    'fighters/player-1-death.png',
    'fighters/player-1-shooting.png',
    'fighters/player-1-shooting.png',
  );

  static PlayerAnimationSet secondSkin() => _defSkin(
    'fighters/player-2.png',
    'fighters/player-2-going.png',
    'fighters/player-2-death.png',
    'fighters/player-2-shooting.png',
    'fighters/player-2-shooting.png',
  );

  static PlayerAnimationSet _defSkin(
    String standingAsset,
    String goingAsset,
    String deathAsset,
    String shootingAsset,
    String reloadAsset) => PlayerAnimationSet(
       standingData:(standingAsset, _defData(2, 0.3, true)),
       goingData: (goingAsset, _defData(4, 0.2, true)),
       deathData: (deathAsset, _defData(4, 0.3, false)),
       shootingData: (shootingAsset, _defData(3, 0.15, false)),
       reloadData: (reloadAsset, _defData(2, 0.15, false)));

  static SpriteAnimationData _defData(int frames, double stepTime, bool loop) =>
      SpriteAnimationData.sequenced(
          amount: frames, textureSize: size, stepTime: stepTime, loop: loop);
}
