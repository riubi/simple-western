import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:simple_western/behavioral/obstaclable.dart';
import 'package:simple_western/behavioral/prioritized.dart';
import 'package:simple_western/behavioral/shadowable.dart';
import 'package:simple_western/config/common_object_asset.dart';

class CommonObject extends PositionComponent
    with Obstaclable, Prioritized, Shadowable {
  final CommonObjectAsset _asset;

  CommonObject(Vector2 position, this._asset) : super(position: position);

  @override
  Future<void> onLoad() async {
    size = Vector2(_asset.hitbox.$1, _asset.hitbox.$2);
    final sprite = await Sprite.load(_asset.asset);
    final spriteSize = sprite.originalSize / 2;
    final spriteComponent = SpriteComponent(sprite: sprite, size: spriteSize)
      ..position
      ..y = size.y - spriteSize.y - 1
      ..x = size.x / 2 - spriteSize.x / 2;

    await addAll({RectangleHitbox(isSolid: true), spriteComponent});

    await super.onLoad();
  }

  static Iterable<CommonObject> getRandoms(List<Vector2> positions) {
    return positions.map((p) => CommonObject(p, CommonObjectAsset.getRandom()));
  }
}
