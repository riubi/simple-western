import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:simple_western/object/cloud.dart';

class Sky extends SpriteComponent {
  static const _sunLeftMargin = 125.0;
  static const _cloudMinSpeed = 10.0;
  static const _cloudMaxSpeed = 30.0;
  static const _bottomLimiter = 275;
  static const _topLimiter = 100;

  static const sun = 'objects/sun.png';
  static const sky = 'backgrounds/sky-bg.png';

  static const cloud1 = 'objects/cloud1.png';
  static const cloud2 = 'objects/cloud2.png';

  final List<Sprite> cloudSprites = [];

  Sky() : super(anchor: Anchor.bottomCenter);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(sky);

    final sprite1 = await Sprite.load(cloud1);
    final sprite2 = await Sprite.load(cloud2);
    final sunSprite = await Sprite.load(sun);

    add(SpriteComponent(
        sprite: sunSprite,
        position: Vector2(
            position.x - _sunLeftMargin, position.y / 2 - _sunLeftMargin)));

    cloudSprites.addAll([sprite1, sprite2]);

    createClouds([-size.x * 0.1, size.x * 0.1, size.x * 0.5, size.x * 0.9]);

    return super.onLoad();
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    if (type == ChildrenChangeType.removed) {
      createCloud();
    }

    super.onChildrenChanged(child, type);
  }

  void createCloud({double? x}) {
    final verticalOffset = Random().nextInt(10) / 10;

    final speed =
        Random().nextInt(100) / 100 * (_cloudMaxSpeed - _cloudMinSpeed) +
            _cloudMinSpeed;

    final sprite = cloudSprites[(speed % 2).toInt()];
    final cloudStartPosition = x ?? -sprite.srcSize.x * 1.3;

    final cloudPosition = Vector2(cloudStartPosition,
        (position.y - _bottomLimiter) * verticalOffset + _topLimiter);
    final cloud = Cloud(speed, sprite, cloudPosition);

    add(cloud);
  }

  void createClouds(List<double> list) {
    for (final element in list) {
      createCloud(x: element);
    }
  }
}
