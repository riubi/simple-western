import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/config/key_binging_set.dart';
import 'package:simple_western/config/player_animation_set.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/scene/match.dart';
import 'package:simple_western/scene/menu.dart';
import 'package:simple_western/ui/guide_screen.dart';
import 'package:simple_western/ui/splash_screen.dart';

import 'object/bot.dart';

class GameApp extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  Match? _match;
  late Menu _menu;
  bool _guideSeen = false;

  GameApp() : super() {
    collisionDetection = StandardCollisionDetection();
  }

  @override
  Future<void> onLoad() async {
    await AudioSet.preload();
    await super.onLoad();

    add(SplashScreen(_showMenu));
  }

  void _showMenu() {
    _menu =
        Menu(_wrapWithGuide(startDuel), _wrapWithGuide(startBattle), _stopGame);

    add(_menu);

    AudioSet.playIntro();
  }

  void Function() _wrapWithGuide(void Function() onComplete) {
    return () {
      if (_guideSeen) {
        return onComplete();
      }
      _guideSeen = true;
      add(GuideScreen(onComplete));
    };
  }

  void startDuel() {
    _startMatch({
      Player(KeyBindingSet.wasd(), PlayerAnimationSet.firstSkin(), label: '1')
    }, {
      Player(KeyBindingSet.arrows(), PlayerAnimationSet.secondSkin(), label: '2')
    });
  }

  void startBattle() {
    final Set<Bot> bots = {};

    for (var i = 0; i < 3; i++) {
      bots.add(Bot(KeyBindingSet.bot(), PlayerAnimationSet.firstSkin()));
    }

    _startMatch({
      Player(KeyBindingSet.wasd(), PlayerAnimationSet.secondSkin(), label: '1'),
      Player(KeyBindingSet.arrows(), PlayerAnimationSet.secondSkin(), label: '2'),
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
