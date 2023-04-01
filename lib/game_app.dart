import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:simple_western/player.dart';
import 'package:simple_western/battle_scene.dart';
import 'package:simple_western/player_key_set.dart';

class GameApp extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final BattleScene battleLayer;
  late final Set<Player> players;

  GameApp(): super() {
    collisionDetection = StandardCollisionDetection();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    players = {
      Player(PlayerKeySet.arrows(), 'fighters/player-1.png'),
      Player(PlayerKeySet.wasd(), 'fighters/player-2.png'),
    };

    battleLayer = BattleScene(players);

    add(battleLayer);
  }
}