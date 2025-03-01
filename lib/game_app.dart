import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/config/key_binging_set.dart';
import 'package:simple_western/config/player_animation_set.dart';
import 'package:simple_western/entity/bot.dart';
import 'package:simple_western/entity/player.dart';
import 'package:simple_western/screens/match.dart';
import 'package:simple_western/screens/menu.dart';

class GameApp extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  Match? _match;
  late Menu _menu;

  GameApp() : super() {
    collisionDetection = StandardCollisionDetection();
  }

  @override
  Future<void> onLoad() async {
    _menu = Menu(startPvpDuel, startPveDuel, startBattle, _stopGame);
    add(_menu);

    await AudioSet.preload();
    await super.onLoad();
  }

  void startPvpDuel() =>
      _startMatch({Player.createFirst()}, {Player.createSecond()});

  void startPveDuel() => _startMatchWithBots({Player.createFirst()}, 1);

  void startBattle() {
    _startMatchWithBots({
      Player.createFirst(),
      Player(KeyBindingSet.arrows(), PlayerAnimationSet.firstSkin(),
          label: '2'),
    }, 2);
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

  void _startMatchWithBots(Set<Player> leftParty, int botsAmount) async {
    final Set<Bot> bots = {};
    for (var i = 0; i < botsAmount; i++) {
      bots.add(Bot(PlayerAnimationSet.secondSkin(), () => leftParty.toList()));
    }

    _startMatch(leftParty, bots);
  }

  void _stopGame() {
    if (_match != null) {
      _match?.removeFromParent();
      _match = null;
    }
  }
}
