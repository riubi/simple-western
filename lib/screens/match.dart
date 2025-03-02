import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:simple_western/entity/player.dart';
import 'package:simple_western/screens/battle.dart';
import 'package:simple_western/screens/sky.dart';

class Match extends PositionComponent with HasGameRef {
  static const _landAsset = 'backgrounds/land-bg.png';
  static const _bgColor = Color.fromRGBO(194, 142, 50, 1);

  static final battleSize = Vector2(800, 320);
  static final Vector2 battlePosition = Vector2(0, 50);

  final Set<Player> _leftTeam;
  final Set<Player> _rightTeam;

  final SpriteComponent _landComponent;
  final Battle _battleLayer;
  final PositionComponent _skyComponent;

  Match(this._leftTeam, this._rightTeam, void Function() battleFinisher)
      : _skyComponent = Sky()..position = battlePosition,
        _landComponent =
            SpriteComponent(anchor: Anchor.topCenter, position: battlePosition),
        _battleLayer =
            Battle(_leftTeam, _rightTeam, battleSize, battlePosition),
        super(anchor: Anchor.topCenter) {
    _handleElimination(_leftTeam, battleFinisher);
    _handleElimination(_rightTeam, battleFinisher);
    _handleHelloPhrase(_leftTeam.union(_rightTeam).toList());
  }

  @override
  Future<void> onLoad() async {
    _landComponent.sprite = await Sprite.load(_landAsset);
    _landComponent.size = _landComponent.sprite!.originalSize;

    resize(gameRef.canvasSize);

    await addAll({_landComponent, _skyComponent, _battleLayer});

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
    position = parentSize / 2;
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
