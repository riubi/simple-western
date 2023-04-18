import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/config/key_binging_set.dart';
import 'package:simple_western/config/player_animation_set.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/scene/match.dart';
import 'package:simple_western/scene/menu.dart';

import 'object/bot.dart';

class GameApp extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection, HasTappables {
  Match? _match;
  late Menu _menu;

  GameApp() : super() {
    collisionDetection = StandardCollisionDetection();
  }

  @override
  Future<void> onLoad() async {
    await AudioSet.preload();

    await super.onLoad();

    _menu = Menu(startDuel, startBattle, _stopGame);

    add(_menu);
  }

  void startDuel() {
    _startMatch({Player(KeyBindingSet.wasd(), PlayerAnimationSet.firstSkin())},
        {Player(KeyBindingSet.arrows(), PlayerAnimationSet.secondSkin())});
  }

  void startBattle() {
    final Set<Bot> bots = {};

    for (var i = 0; i < 4; i++) {
      bots.add(Bot(KeyBindingSet.bot(), PlayerAnimationSet.firstSkin()));
    }

    _startMatch({
      Player(KeyBindingSet.wasd(), PlayerAnimationSet.secondSkin()),
      Player(KeyBindingSet.arrows(), PlayerAnimationSet.secondSkin()),
    }, bots);
  }

  void _startMatch(Set<Player> leftParty, Set<Player> rightParty) async {
    _stopGame();

    _match = Match(leftParty, rightParty, () {
      AudioSet.playLobbyAudio();
      _menu.openEndGameMenu();
    });

    AudioSet.playMatchAudio();

    await add(_match!);
  }

  void _stopGame() {
    if (_match != null) {
      _match?.removeFromParent();
      _match = null;
    }
  }
}
