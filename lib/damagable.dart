import 'package:flame/components.dart';

mixin Damagable on PositionComponent {
  bool eliminated = false;
  late int hp;

  void damage(int strength) {
    if (eliminated) {
      return;
    }

    print('Target damaged: $strength, hp: $hp');

    hp -= strength;
    if (hp <= 0) {
      eliminated = true;
      onEliminating();
    }
  }

  void onEliminating();
}