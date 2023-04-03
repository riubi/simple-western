import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/behavioral/obstaclable.dart';
import 'package:simple_western/behavioral/prioritizable.dart';
import 'package:simple_western/behavioral/shadowable.dart';

class CommonObject extends PositionComponent
    with Obstaclable, Prioritizable, Shadowable {
  static const cactus = 'objects/cactus.png';
  static const bush = 'objects/bush.png';
  static const grass = 'objects/grass.png';
  static const tree = 'objects/tree.png';

  static final _hitBoxes = {
    cactus: Vector2.all(50),
    bush: Vector2.all(50),
    grass: Vector2.all(50),
    tree: Vector2.all(50),
  };

  static const _randoms = [cactus, bush, grass, tree];

  final String _asset;

  CommonObject(this._asset, position, size)
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    final sprite = await Sprite.load(_asset);
    final spriteSize = sprite!.originalSize * 0.6;

    await addAll(
        {RectangleHitbox(), SpriteComponent(sprite: sprite, size: spriteSize)});

    await super.onLoad();
  }

  static CommonObject getRandom(Vector2 position) {
    final generate = Random().nextInt(_randoms.length);
    final asset = _randoms[generate];

    return CommonObject(asset, position, _hitBoxes[asset]);
  }

  static Iterable<CommonObject> getRandoms(List<Vector2> positions) {
    return positions.map((p) => getRandom(p));
  }
}
