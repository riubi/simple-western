import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/behavioral/controllable.dart';
import 'package:simple_western/behavioral/damageable.dart';
import 'package:simple_western/behavioral/obstaclable.dart';
import 'package:simple_western/behavioral/prioritized.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/config/key_binging_set.dart';
import 'package:simple_western/config/player_animation_set.dart';
import 'package:simple_western/object/bullet.dart';
import 'package:simple_western/object/gun.dart';
import 'package:simple_western/object/player_animation.dart';

import '../ui/floating_text.dart';

class Player extends PositionComponent
    with
        Controllable,
        Obstaclable,
        Prioritized,
        Damageable,
        CollisionCallbacks,
        HasGameRef {
  static const _xSpeed = 180;
  static const _ySpeed = 120;
  static final _defaultSize = Vector2(21, 27);
  static final _bulletOffset = Vector2(32, 8);

  static final _deathPhraseChance = 40;

  @override
  late final PlayerAnimation animation;

  late final RectangleHitbox hitBox = RectangleHitbox(isSolid: true);
  late final Gun gun = Gun({this});

  @override
  // ignore: overridden_fields
  int hp = 6;

  var label = '';

  final List<String> _helloPhrases = [
    "Let's see who's faster!",
    'Fastest gun win!',
    "Ain't my first rodeo..",
    "Let's dance, cowboy!",
    'Hope your mama\nkissed you goodbye!',
    "You'll eat dust!",
  ];

  final List<String> _deathPhrases = [
    'Tell my horse...\nI love her...',
    'Tell my cow...\nI’m not coming home...',
    "I ain't dead...\nyet...",
    'That was a..',
    'Cheap shot!',
    'I’ll be back...\nin another game!',
    'Even legends fall...',
    'Somebody avenge me!',
  ];

  Player(KeyBindingSet keySet, PlayerAnimationSet animationSet,
      {this.label = ''})
      : super(size: _defaultSize) {
    initControl(_xSpeed, _ySpeed, keySet, () => animation.isBlocked);

    add(gun..addClipHandler(_sayWhenNoAmmo));

    animation = PlayerAnimation(
        size, currentStates, gun.preShoot, gun.shoot, gun.reload, animationSet);
  }

  static Player createFirst() =>
      Player(KeyBindingSet.wasd(), PlayerAnimationSet.firstSkin(), label: '1');

  static Player createSecond() =>
      Player(KeyBindingSet.arrows(), PlayerAnimationSet.secondSkin(),
          label: '2');

  @override
  Future<void> onLoad() async {
    await addAll({animation, hitBox});
    await super.onLoad();
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    if (type == ChildrenChangeType.added && child is Bullet) {
      child.parent = parent!;

      child.position = position + _bulletOffset;
      if (isTurnLeft()) {
        child.position.x -= animation.size.x / 2 + _bulletOffset.x;
      }
    }
  }

  @override
  void onEliminating() {
    super.onEliminating();

    AudioSet.play(AudioSet.manDeath);

    _sayEliminatingPhrase();
    hitBox.size.y /= 2;
    hitBox.position.y += hitBox.size.y;

    dead();
  }

  void sayPhrase(String phrase) =>
      add(FloatingText(phrase, Vector2(size.x / 2, -10)));

  void sayHello() =>
      sayPhrase(_helloPhrases[Random().nextInt(_helloPhrases.length)]);

  void _sayWhenNoAmmo(int clipSize) {
    if (clipSize == 0) {
      sayPhrase('No Ammo!');
    }
  }

  void _sayEliminatingPhrase() {
    if (_hasTargeted(_deathPhraseChance)) {
      sayPhrase(_deathPhrases[Random().nextInt(_deathPhrases.length)]);
    }
  }

  bool _hasTargeted(int chance) => Random().nextInt(100) <= chance;
}
