import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

mixin Damageable on PositionComponent {
  bool eliminated = false;
  late int hp;
  final List<void Function(int)> _onDamage = [];
  final List<void Function()> _onEliminate = [];

  void damage(int strength) {
    if (eliminated) {
      return;
    }

    hp -= strength;
    onDamaging(strength);

    if (hp <= 0) {
      eliminated = true;
      onEliminating();
    }
  }

  void onDamaging(int strength) async {
    print('Target damaged: $strength, hp: $hp');
    for (final fn in _onDamage) {
      fn(hp);
    }
  }

  @mustCallSuper
  void onEliminating() {
    print('Target eliminating.');
    for (final fn in _onEliminate) {
      fn();
    }
  }

  void addDamageHandler(void Function(int) handler) {
    _onDamage.add(handler);
  }

  void addEliminatingHandler(void Function() handler) {
    _onEliminate.add(handler);
  }
}
