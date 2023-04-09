import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/config/key_binging_set.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/scene/match.dart';
import 'package:simple_western/scene/menu.dart';

import 'object/bot.dart';

class GameApp extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection, HasTappables {
  late Set<Player> _players;
  Match? _match;
  late Menu _menu;

  GameApp() : super() {
    collisionDetection = StandardCollisionDetection();
  }

  @override
  Future<void> onLoad() async {
    await AudioSet.preload();

    await super.onLoad();

    _menu = Menu(startMatch, stopGame);

    add(_menu);
  }

  void startMatch() async {
    stopGame();

    _players = {
      Bot(
          KeyBindingSet.bot(),
          'fighters/player-1.png',
          'fighters/player-1-going.png',
          'fighters/player-1-shooting.png',
          'fighters/player-1-death.png'),
      Bot(
          KeyBindingSet.bot(),
          'fighters/player-1.png',
          'fighters/player-1-going.png',
          'fighters/player-1-shooting.png',
          'fighters/player-1-death.png'),
      Bot(
          KeyBindingSet.bot(),
          'fighters/player-1.png',
          'fighters/player-1-going.png',
          'fighters/player-1-shooting.png',
          'fighters/player-1-death.png'),
      Bot(
          KeyBindingSet.bot(),
          'fighters/player-1.png',
          'fighters/player-1-going.png',
          'fighters/player-1-shooting.png',
          'fighters/player-1-death.png'),
      Bot(
          KeyBindingSet.bot(),
          'fighters/player-1.png',
          'fighters/player-1-going.png',
          'fighters/player-1-shooting.png',
          'fighters/player-1-death.png'),
      Player(
          KeyBindingSet.arrows(),
          'fighters/player-2.png',
          'fighters/player-2-going.png',
          'fighters/player-2-shooting.png',
          'fighters/player-2-death.png'),
    };

    _match = Match(_players, () {
      AudioSet.playLobbyAudio();
      _menu.openEndGameMenu();
    });

    AudioSet.playMatchAudio();

    await add(_match!);
  }

  void stopGame() {
    if (_match != null) {
      _match?.removeFromParent();
      _match = null;
    }
  }
}
