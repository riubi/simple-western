import 'dart:math';
import 'package:simple_western/behavioral/object_state.dart';
import 'package:simple_western/object/player.dart';

class Bot extends Player {
  final _actions = [
    ObjectState.shoot,
    ObjectState.reload,
    ObjectState.up,
    ObjectState.left,
    ObjectState.right,
    ObjectState.down
  ];

  double _timeToAction = 0;

  Bot(keySet, asset, goingAsset, shootingAsset, deathAsset)
      : super(keySet, asset, goingAsset, shootingAsset, deathAsset);

  @override
  void update(double dt) {
    if (currentStates.contains(ObjectState.dead)) {
      return;
    }

    _timeToAction -= dt;

    if (_timeToAction <= 0) {
      final nextTime = 1 + Random().nextInt(50) / 100;
      _timeToAction = nextTime;

      final nextActionIndex = Random().nextInt(_actions.length);
      currentStates
        ..clear()
        ..add(_actions[nextActionIndex]);
    }

    super.update(dt);
  }
}
