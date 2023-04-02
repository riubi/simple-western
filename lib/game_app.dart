import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:audioplayers/src/audioplayer.dart';
import 'package:simple_western/audio_manager.dart';
import 'package:simple_western/player.dart';
import 'package:simple_western/battle_scene.dart';
import 'package:simple_western/player_binging_set.dart';

class GameApp extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final BattleScene battleLayer;
  late final Set<Player> players;
  // late AudioPlayer? lobbyAudio;

  GameApp() : super() {
    collisionDetection = StandardCollisionDetection();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await AudioManager.preload();

    players = {
      Player(PlayerBindingSet.arrows(), 'fighters/player-1.png',
          'fighters/player-1-shooting.png', 'fighters/player-1-death.png'),
      Player(PlayerBindingSet.wasd(), 'fighters/player-2.png',
          'fighters/player-2-shooting.png', 'fighters/player-2-death.png'),
    };

    // await AssetManager.playAudio(AssetManager.lobbyAudio, volume: 1)
    //     .then((audio) => lobbyAudio = audio);

    startMatch(players);
  }

  void startMatch(Set<Player> players) {
    // lobbyAudio?.stop();
    add(BattleScene(players));
  }
}
