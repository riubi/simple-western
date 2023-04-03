import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/behavioral/controlable.dart';
import 'package:simple_western/behavioral/prioritizable.dart';
import 'package:simple_western/behavioral/obstaclable.dart';
import 'package:simple_western/behavioral/shadowable.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/config/global_config.dart';
import 'package:simple_western/behavioral/damagable.dart';
import 'package:simple_western/object/player_animation.dart';
import 'package:simple_western/object/bullet.dart';

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
  static const _hp = 4;
  static final _defaultSize = Vector2(21, 27);
  static final _bulletPosition = Vector2(32, 8);

  late final PlayerAnimation sprite;
  late final RectangleHitbox hitbox;

  Player(keySet, asset, shootingAsset, deathAsset) : super(size: _defaultSize) {
    debugMode = GlobalConfig.debugMode;

    initControl(_xSpeed, _ySpeed, keySet, () => sprite.isBlocked);

    hp = _hp;
    hitbox = RectangleHitbox();

    sprite = PlayerAnimation(
        size, currentStates, shoot, asset, shootingAsset, deathAsset);
  }

  @override
  Future<void> onLoad() async {
    await addAll({sprite, hitbox});

    await super.onLoad();
  }

  void shoot() {
    final fixedPosition = position + _bulletPosition;
    if (anchor == Anchor.topRight) {
      fixedPosition.x -= size.x / 2 + _bulletPosition.x;
    }

    parent
        ?.add(Bullet(fixedPosition, anchor == Anchor.topLeft ? 1 : -1, {this}));
  }

  @override
  void onEliminating() {
    super.onEliminating();

    AudioSet.play(AudioSet.manDeath);
    dead();

    hitbox.size.y /= 2;
    hitbox.position.y += hitbox.size.y;
  }
}
