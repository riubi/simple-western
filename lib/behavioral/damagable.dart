import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

mixin Damagable on PositionComponent {
  bool eliminated = false;
  late int hp;
  final List<void Function(int)> _onDamage = [];
  final List<void Function()> _onEliminate = [];

  void damage(int strength) {
    if (eliminated) {
      return;
    }

    hp -= strength;

    print('Target damaged: $strength, hp: $hp');
    _onDamage.forEach((fn) => fn(hp));

    if (hp <= 0) {
      eliminated = true;
      onEliminating();
    }
  }

  @mustCallSuper
  void onEliminating() {
    print('Target eliminating.');

    _onEliminate.forEach((fn) => fn());
  }

  void addDamageHandler(void Function(int) handler) {
    _onDamage.add(handler);
  }

  void addEliminatingHandler(void Function() handler) {
    _onEliminate.add(handler);
  }
}
