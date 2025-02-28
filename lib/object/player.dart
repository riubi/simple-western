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

  @override
  late final PlayerAnimation animation;

  late final RectangleHitbox hitBox = RectangleHitbox(isSolid: true);
  late final Gun gun = Gun({this});

  @override
  // ignore: overridden_fields
  int hp = 6;

  var label = '';

  Player(KeyBindingSet keySet, PlayerAnimationSet animationSet,
      {this.label = ''})
      : super(size: _defaultSize) {
    initControl(_xSpeed, _ySpeed, keySet, () => animation.isBlocked);

    add(gun);

    animation = PlayerAnimation(
        size, currentStates, gun.preShoot, gun.shoot, gun.reload, animationSet);
  }

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

    hitBox.size.y /= 2;
    hitBox.position.y += hitBox.size.y;

    dead();
  }
}
