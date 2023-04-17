import 'package:flame/components.dart';

class PlayerAnimationSet {
  final Vector2 size = Vector2.all(192);

  final String standingData;
  final String goingData;
  final String deathData;
  final String reloadData;
  final String shootingData;

  PlayerAnimationSet(this.standingData, this.goingData, this.deathData,
      this.reloadData, this.shootingData);

  static PlayerAnimationSet firstSkin() => PlayerAnimationSet(
        'fighters/player-1.png',
        'fighters/player-1-going.png',
        'fighters/player-1-death.png',
        'fighters/player-1-shooting.png',
        'fighters/player-1-shooting.png',
      );

  static PlayerAnimationSet secondSkin() => PlayerAnimationSet(
        'fighters/player-2.png',
        'fighters/player-2-going.png',
        'fighters/player-2-death.png',
        'fighters/player-2-shooting.png',
        'fighters/player-2-shooting.png',
      );
}
