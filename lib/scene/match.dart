import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/scene/battle.dart';
import 'package:simple_western/scene/sky.dart';

class Match extends PositionComponent with HasGameRef {
  static const _landAsset = 'backgrounds/land-bg.png';
  static const _bgColor = Color.fromRGBO(194, 142, 50, 1);
  static const _topOffset = 320;
  static const _minSkyHeight = 500.0;
  static const _maxSkyWidth = 1720.0;
  static const _resizeFactorX = .5;
  static const _resizeFactorY = .9;

  static final battleSize = Vector2(800, 320);
  final Vector2 battlePosition = Vector2.all(0);

  final Set<Player> _leftTeam;
  final Set<Player> _rightTeam;

  late SpriteComponent landComponent;
  late Battle battleLayer;
  late SpriteComponent skyComponent;

  Match(this._leftTeam, this._rightTeam, void Function() battleFinisher) {
    skyComponent = Sky();
    landComponent = SpriteComponent(anchor: Anchor.topCenter);
    battleLayer = Battle(_leftTeam, _rightTeam, battleSize, battlePosition);

    _handleElimination(_leftTeam, battleFinisher);
    _handleElimination(_rightTeam, battleFinisher);
    _handleHelloPhrase(_leftTeam.union(_rightTeam).toList());
  }

  @override
  Future<void> onLoad() async {
    landComponent.sprite = await Sprite.load(_landAsset);
    landComponent.size = landComponent.sprite!.originalSize;

    resize(gameRef.canvasSize);

    await addAll({landComponent, skyComponent, battleLayer});

    await super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas..drawColor(_bgColor, BlendMode.src));
  }

  @override
  void onGameResize(Vector2 size) {
    resize(size);
    super.onGameResize(size);
  }

  void resize(Vector2 parentSize) {
    battlePosition.x = parentSize.x * _resizeFactorX;
    battlePosition.y = parentSize.y * _resizeFactorY - _topOffset;

    skyComponent
      ..position = battlePosition + Vector2(0, 1)
      ..size = Vector2(
          min(parentSize.x, _maxSkyWidth),
          skyComponent.size.y < _minSkyHeight
              ? _minSkyHeight
              : skyComponent.size.y);

    landComponent.position = battlePosition;
    battleLayer.position = battlePosition;
  }

  void _handleElimination(Set<Player> team, void Function() battleFinisher) {
    var teamSize = team.length;
    for (final player in team) {
      player.addEliminatingHandler(() async {
        teamSize--;
        if (teamSize <= 0) {
          Future.delayed(const Duration(seconds: 1), () {
            battleFinisher();
          });
        }
      });
    }
  }

  void _handleHelloPhrase(List<Player> players) =>
      players[Random().nextInt(players.length)].sayHello();
}
