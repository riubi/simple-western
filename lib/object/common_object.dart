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
    cactus: Vector2(24, 27),
    bush: Vector2(24, 11),
    grass: Vector2(24, 14),
    tree: Vector2(22, 46),
  };

  static const _randoms = [cactus, bush, grass, tree];

  final String _asset;

  CommonObject(this._asset, position, size)
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    final sprite = await Sprite.load(_asset);
    final spriteSize = sprite.originalSize * 0.5;

    final spriteComponent = SpriteComponent(sprite: sprite, size: spriteSize)
      ..position
      ..y = size.y - spriteSize.y - 1
      ..x = size.x / 2 - spriteSize.x / 2;

    await addAll({RectangleHitbox(isSolid: true), spriteComponent});

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
