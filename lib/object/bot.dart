import 'dart:math';

import 'package:simple_western/behavioral/object_state.dart';
import 'package:simple_western/object/player.dart';

class Bot extends Player {
  static const _minTimeReaction = .3;
  static const _extraMaxDuration = 1;
  static const _shootingTime = .35;
  static const _reloadingTime = .75;

  final _actions = [
    ObjectState.up,
    ObjectState.left,
    ObjectState.right,
    ObjectState.down
  ];

  double _timeToAction = 0;

  Bot(super.keySet, super.animationSet);

  @override
  void update(double dt) {
    if (eliminated) {
      return;
    }

    _timeToAction -= dt;

    if (_timeToAction <= 0) {
      currentStates.clear();

      if (Random().nextInt(4) == 0) {
        _shoot();
      } else {
        _goToRandom();
      }
    }

    super.update(dt);
  }

  void _goToRandom() {
    _timeToAction = _minTimeReaction + Random().nextInt(_extraMaxDuration) / 1;
    final nextActionIndex = Random().nextInt(_actions.length);
    currentStates.add(_actions[nextActionIndex]);
  }

  void _shoot() {
    if (gun.bulletCounts > 0) {
      _timeToAction = _shootingTime + Random().nextInt(_extraMaxDuration) / 3;
      currentStates.add(ObjectState.shoot);
    } else {
      _timeToAction = _reloadingTime;
      currentStates.add(ObjectState.reload);
    }
  }
}
