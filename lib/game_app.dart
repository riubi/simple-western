import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/config/key_binging_set.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/scene/match.dart';
import 'package:simple_western/scene/menu.dart';

class GameApp extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection, HasTappables {
  late Set<Player> players;

  GameApp() : super() {
    collisionDetection = StandardCollisionDetection();
  }

  @override
  Future<void> onLoad() async {
    await AudioSet.preload();

    await super.onLoad();

    add(Menu(startMatch));

    AudioSet.playLobbyAudio();
  }

  void startMatch() async {
    players = {
      Player(KeyBindingSet.wasd(), 'fighters/player-1.png',
          'fighters/player-1-shooting.png', 'fighters/player-1-death.png'),
      Player(KeyBindingSet.arrows(), 'fighters/player-2.png',
          'fighters/player-2-shooting.png', 'fighters/player-2-death.png'),
    };

    await add(Match(players));
  }
}
