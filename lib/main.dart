import 'package:flame/game.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:simple_western/game_app.dart';

void main() {
  final game = GameWidget(game: GameApp());

  runApp(MaterialApp(
    home: Scaffold(
      body: FlameSplashScreen(
        theme: FlameSplashTheme.dark,
        onFinish: (context) => Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute(builder: (context) => game),
        ),
      ),
    ),
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
  ));
}
