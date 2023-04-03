import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

mixin Damagable on PositionComponent {
  bool eliminated = false;
  late int hp;
  final List<Function(int)> _onDamage = [];

  void damage(int strength) {
    if (eliminated) {
      return;
    }

    hp -= strength;
    print('Target damaged: $strength, hp: $hp');

    if (_onDamage.isNotEmpty) {
      for (var fn in _onDamage) {
        fn(hp);
      }
    }

    if (hp <= 0) {
      onEliminating();
    }
  }

  @mustCallSuper
  void onEliminating() {
    eliminated = true;
    print('Target eliminating.');
  }

  addDamageHandler(Function(int) handler) {
    _onDamage.add(handler);
  }
}
