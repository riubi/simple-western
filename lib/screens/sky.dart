import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:simple_western/interface/gradient_background.dart';
import 'package:simple_western/interface/painted_background.dart';
import 'package:simple_western/object/cloud.dart';

class Sky extends PositionComponent with HasGameRef {
  static const _minSkyHeight = 500.0;
  static const _minSkyWidth = 1200.0;
  static const _maxSkyWidth = 1720.0;
  static const _sunHeightFactor = .95;
  static const _cloudMinSpeed = 8.0;
  static const _cloudMaxSpeed = 30.0;
  static const _bottomLimiter = 150;
  static const _topLimiter = 75;
  static const _starterCloudPositions = [-.9, -.4, 0.6, 0.9];

  static const _sun = 'objects/sun.png';
  static const _sky = 'backgrounds/sky-bg.png';

  static const _cloud1 = 'objects/cloud1.png';
  static const _cloud2 = 'objects/cloud2.png';

  static const _topBgColor = Color(0xFFEDA540);
  static const _bottomBgColor = Color(0xFFFADF9E);

  final PaintedBackground _paintedBgComponent;
  final GradientBackground _gradientBgComponent;
  final SpriteComponent _sunComponent;
  final SpriteComponent _skyComponent;

  final List<Sprite> cloudSprites = [];

  Sky()
      : _paintedBgComponent = PaintedBackground(_topBgColor),
        _gradientBgComponent = GradientBackground(_topBgColor, _bottomBgColor),
        _sunComponent = SpriteComponent(anchor: Anchor.topCenter),
        _skyComponent = SpriteComponent(anchor: Anchor.bottomCenter),
        super(anchor: Anchor.bottomCenter);

  @override
  FutureOr<void> onLoad() async {
    _sunComponent.sprite = await Sprite.load(_sun);
    _skyComponent.sprite = await Sprite.load(_sky);

    final sprite1 = await Sprite.load(_cloud1);
    final sprite2 = await Sprite.load(_cloud2);

    cloudSprites.addAll([sprite1, sprite2]);

    await addAll([
      _paintedBgComponent,
      _gradientBgComponent,
      _skyComponent,
      _sunComponent,
      ...createClouds(_skyComponent.width / 2)
    ]);

    resize(gameRef.canvasSize);

    return super.onLoad();
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    if (type == ChildrenChangeType.removed) {
      add(createCloud());
    }

    super.onChildrenChanged(child, type);
  }

  Cloud createCloud({double? x}) {
    final randomFactor = Random().nextInt(10) / 9;

    final speed =
        Random().nextInt(100) / 100 * (_cloudMaxSpeed - _cloudMinSpeed) +
            _cloudMinSpeed;

    final sprite = cloudSprites[(speed % 2).toInt()];

    final cloudStartPosition =
        x ?? (-sprite.srcSize.x - _skyComponent.width / 2);

    final verticalPosition =
        -((_skyComponent.height - _topLimiter - _bottomLimiter) * randomFactor +
            _bottomLimiter);

    final cloudPosition = Vector2(cloudStartPosition, verticalPosition);

    return Cloud(speed, sprite, cloudPosition);
  }

  List<Cloud> createClouds(double bgWidth) {
    final clouds = <Cloud>[];

    for (final horizontalFactor in _starterCloudPositions) {
      clouds.add(createCloud(x: bgWidth * horizontalFactor));
    }

    return clouds;
  }

  @override
  void onGameResize(Vector2 size) {
    resize(size);

    super.onGameResize(size);
  }

  void resize(Vector2 parentSize) {
    _skyComponent.size = Vector2(
        max(min(parentSize.x, _maxSkyWidth), _minSkyWidth),
        size.y < _minSkyHeight ? _minSkyHeight : size.y);

    _sunComponent.position.y = -_skyComponent.height * _sunHeightFactor;

    _paintedBgComponent
      ..size.x = gameRef.size.x
      ..size.y = gameRef.size.y / 2 + position.y;

    _gradientBgComponent
      ..size.x = gameRef.size.x
      ..size.y = _skyComponent.height;
  }
}
