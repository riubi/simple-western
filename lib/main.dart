import 'package:flame/game.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/game_app.dart';

void main() {
  final game = GameWidget(game: GameApp());

  runApp(MyApp(game));
}

class MyApp extends StatelessWidget {
  final GameWidget<Game> game;

  const MyApp(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreenGame(game),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreenGame extends StatefulWidget {
  final GameWidget<Game> game;

  const SplashScreenGame(this.game, {super.key});

  @override
  SplashScreenGameState createState() => SplashScreenGameState(game);
}

class SplashScreenGameState extends State<SplashScreenGame> {
  final GameWidget<Game> game;

  SplashScreenGameState(this.game);

  late FlameSplashController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlameSplashScreen(
        showAfter: (BuildContext context) {
          AudioSet.preloadAndPlayIntro();
          return Image.asset('assets/images/ui/logo.png', width: 550);
        },
        theme: FlameSplashTheme.dark,
        onFinish: (context) => Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute(builder: (context) => game),
        ),
      ),
    );
  }
}
