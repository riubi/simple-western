import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/behavioral/controlable.dart';
import 'package:simple_western/behavioral/prioritizable.dart';
import 'package:simple_western/behavioral/obstaclable.dart';
import 'package:simple_western/behavioral/shadowable.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/config/global_config.dart';
import 'package:simple_western/behavioral/damagable.dart';
import 'package:simple_western/object/bullet.dart';
import 'package:simple_western/object/gun.dart';
import 'package:simple_western/object/player_animation.dart';

class Player extends PositionComponent
    with
        Controlable,
        Obstaclable,
        Prioritizable,
        Damagable,
        Shadowable,
        CollisionCallbacks,
        HasGameRef {
  static const _xSpeed = 180;
  static const _ySpeed = 120;
  static const _hp = 5;
  static final _defaultSize = Vector2(21, 27);

  late final PlayerAnimation animation;

  late final RectangleHitbox hitbox = RectangleHitbox(isSolid: true);
  late final Gun gun = Gun({this});

  @override
  late int hp = _hp;

  Player(keySet, animationSet)
      : super(size: _defaultSize) {
    debugMode = GlobalConfig.debugMode;

    initControl(_xSpeed, _ySpeed, keySet, () => animation.isBlocked);

    add(gun);

    animation = PlayerAnimation(
        size,
        currentStates,
        gun.preShoot,
        gun.shoot,
        gun.reload,
        () => super.onEliminating(),
        animationSet);
  }

  @override
  Future<void> onLoad() async {
    await addAll({animation, hitbox});

    await super.onLoad();
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    if (type == ChildrenChangeType.added && child is Bullet) {
      child.changeParent(parent!);

      var offset = Vector2(32, 8);

      var isTurnedLeft = anchor.x == 1.0;
      child.position = position + offset;
      if (isTurnedLeft) {
        child.position.x -= 35 + offset.x;
      }
    }
  }

  @override
  void onEliminating() {
    AudioSet.play(AudioSet.manDeath);

    hitbox.size.y /= 2;
    hitbox.position.y += hitbox.size.y;

    dead();
  }
}
