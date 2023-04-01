import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:simple_western/game_app.dart';

void main() {
  final app = GameApp();
  runApp(
    GameWidget(
      game: app,
    ),
  );
}