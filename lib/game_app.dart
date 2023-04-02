import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/config/player_binging_set.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/scene/match.dart';

class GameApp extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final Match matchLayer;
  late final Set<Player> players;
  // late AudioPlayer? lobbyAudio;

  GameApp() : super() {
    collisionDetection = StandardCollisionDetection();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await AudioSet.preload();

    players = {
      Player(PlayerBindingSet.wasd(), 'fighters/player-1.png',
          'fighters/player-1-shooting.png', 'fighters/player-1-death.png'),
      Player(PlayerBindingSet.arrows(), 'fighters/player-2.png',
          'fighters/player-2-shooting.png', 'fighters/player-2-death.png'),
    };

    startMatch(players);
    //AudioManager.playLobbyAudio();
  }

  void startMatch(Set<Player> players) {
    add(Match(players));
  }
}
