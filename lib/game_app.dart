import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:simple_western/player.dart';
import 'package:simple_western/battle_scene.dart';
import 'package:simple_western/player_binging_set.dart';

class GameApp extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final BattleScene battleLayer;
  late final Set<Player> players;

  GameApp() : super() {
    collisionDetection = StandardCollisionDetection();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    players = {
      Player(PlayerBindingSet.arrows(), 'fighters/player-1.png','fighters/player-1-shooting.png'),
      Player(PlayerBindingSet.wasd(), 'fighters/player-2.png', 'fighters/player-2-shooting.png'),
    };

    battleLayer = BattleScene(players);

    add(battleLayer);
  }
}