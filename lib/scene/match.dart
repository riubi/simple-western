import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:simple_western/config/global_config.dart';
import 'package:simple_western/scene/battle.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/scene/sky.dart';

class Match extends PositionComponent with HasGameRef {
  static const _landAsset = 'backgrounds/land-bg.png';
  static const _bgColor = Color.fromRGBO(194, 142, 50, 1);
  static const _topOffset = 320;

  static final battleSize = Vector2(800, 320);
  final Vector2 battlePosition = Vector2.all(0);

  final Set<Player> _leftTeam;
  final Set<Player> _rightTeam;

  late SpriteComponent landComponent;
  late Battle battleLayer;
  late SpriteComponent skyComponent;

  Match(this._leftTeam, this._rightTeam, void Function() battleFinisher) {
    debugMode = GlobalConfig.debugMode;

    skyComponent = Sky();
    landComponent = SpriteComponent(anchor: Anchor.topCenter);
    battleLayer = Battle(_leftTeam, _rightTeam, battleSize, battlePosition);

    for (final team in {_leftTeam, _rightTeam}) {
      var teamSize = team.length;
      for (final partner in team) {
        partner.addEliminatingHandler(() {
          teamSize--;
          if (teamSize <= 0) {
            battleFinisher();
          }
        });
      }
    }
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
    battlePosition.x = parentSize.x * 0.5;
    battlePosition.y = parentSize.y * 0.9 - _topOffset;

    skyComponent
      ..position = battlePosition + Vector2(0, 1)
      ..size = Vector2(parentSize.x, skyComponent.size.y);

    landComponent.position = battlePosition;
    battleLayer.position = battlePosition;
  }
}
