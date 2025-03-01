import 'package:flame/game.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:simple_western/config/platforms.dart';
import 'package:simple_western/game_app.dart';
import 'package:simple_western/screens/not_supported.dart';

void main() {
  if (Platforms.isMobile()) {
    return runApp(NotSupported());
  }

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
