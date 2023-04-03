import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/config/key_binging_set.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/scene/match.dart';

class GameApp extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final Match matchLayer;
  late final Set<Player> players;

  GameApp() : super() {
    collisionDetection = StandardCollisionDetection();
  }

  @override
  Future<void> onLoad() async {
    await AudioSet.preload();

    await super.onLoad();

    players = {
      Player(KeyBindingSet.wasd(), 'fighters/player-1.png',
          'fighters/player-1-shooting.png', 'fighters/player-1-death.png'),
      Player(KeyBindingSet.arrows(), 'fighters/player-2.png',
          'fighters/player-2-shooting.png', 'fighters/player-2-death.png'),
    };

    startMatch(players);

    // AudioSet.playLobbyAudio();
  }

  void startMatch(Set<Player> players) async {
    await add(Match(players));
  }
}
