import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

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
      onEliminating();
    }
  }

  @mustCallSuper
  void onEliminating() {
    eliminated = true;
    print('Target eliminating.');
  }
}
