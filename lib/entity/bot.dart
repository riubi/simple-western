import 'dart:math';
import 'package:flame/components.dart';
import 'package:simple_western/behavioral/object_state.dart';
import 'package:simple_western/entity/player.dart';
import '../config/key_binging_set.dart';
import '../config/player_animation_set.dart';

class Bot extends Player {
  static const double _minReactionTime = 0.3;
  static const double _maxExtraReactionTime = 1.0;
  static const double _shootingTime = 0.35;
  static const double _reloadingTime = 0.95;
  static const double _stopToShootDistance = 280.0;
  static const double _changeDirectionCooldown = 1.0;
  static const double _acceptableDistanceX = 250;
  static const double _acceptableDistanceY = 4;
  static const double _turnThreshold = 20;

  final _movementActions = [
    ObjectState.up,
    ObjectState.left,
    ObjectState.right,
    ObjectState.down
  ];

  double _timeToAction = 0;
  double _timeSinceDirectionChange = 0;
  Player? _target;
  final List<Player> Function() _targetsFinder;

  Bot(PlayerAnimationSet animationSet, this._targetsFinder)
      : super(KeyBindingSet.bot(), animationSet);

  @override
  void update(double dt) {
    if (eliminated) return;

    _timeToAction -= dt;
    _timeSinceDirectionChange += dt;

    if (_target == null || _target!.eliminated) {
      _findClosestTarget();
    }

    if (_timeToAction <= 0) {
      _checkAndTurnToTarget();
      if (_target != null) {
        _chaseOrShoot();
      } else {
        _wanderRandomly();
      }
    }

    super.update(dt);
  }

  void _findClosestTarget() {
    final targets = _targetsFinder();
    if (targets.isEmpty) return;

    double closestDistance = double.infinity;
    Player? closestPlayer;

    for (final player in targets) {
      if (player == this || player.eliminated) continue;

      double distance = position.distanceTo(player.position);
      if (distance < closestDistance) {
        closestDistance = distance;
        closestPlayer = player;
      }
    }

    _target = closestPlayer;
  }

  void _checkAndTurnToTarget() {
    if (_target == null) return;

    final targetX = _target!.position.x;
    final botX = position.x;

    if ((targetX - botX).abs() < _turnThreshold) return;

    if (targetX < botX && isTurnRight()) return turnLeft();

    if (targetX > botX && isTurnLeft()) return turnRight();
  }

  void _chaseOrShoot() {
    if (_target == null) return;

    final distance = position.distanceTo(_target!.position);
    if (distance < _stopToShootDistance && _hasOneLineWithTarget(_target!)) {
      _stopAndShoot();
    } else {
      _moveTowards(_target!);
    }
  }

  void _stopAndShoot() {
    currentStates.clear();
    _shoot();
  }

  void _moveTowards(Player target) {
    if (_timeSinceDirectionChange < _changeDirectionCooldown) return;

    _timeToAction = _minReactionTime;
    _timeSinceDirectionChange = 0;

    currentStates.clear();

    if ((target.position.x - position.x).abs() > _acceptableDistanceX) {
      currentStates.add(target.position.x > position.x
          ? ObjectState.right
          : ObjectState.left);
    }

    if (!_hasOneLineWithTarget(target)) {
      currentStates.add(
          target.position.y > position.y ? ObjectState.down : ObjectState.up);
    }
  }

  void _wanderRandomly() {
    _timeToAction =
        _minReactionTime + Random().nextDouble() * _maxExtraReactionTime;
    final nextActionIndex = Random().nextInt(_movementActions.length);
    currentStates.clear();
    currentStates.add(_movementActions[nextActionIndex]);
  }

  void _shoot() {
    if (gun.bulletCounts > 0) {
      _timeToAction = _shootingTime;
      currentStates.add(ObjectState.shoot);
    } else {
      _timeToAction = _reloadingTime;
      currentStates.add(ObjectState.reload);
    }
  }

  bool _hasOneLineWithTarget(PositionComponent target) =>
      (target.position.y - position.y).abs() < _acceptableDistanceY;
}
