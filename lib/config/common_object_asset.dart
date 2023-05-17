import 'dart:math';

enum CommonObjectAsset {
  cactus (asset: 'objects/cactus.png', hitbox: (24, 27)),
  bush (asset: 'objects/bush.png', hitbox: (24, 11)),
  grass (asset: 'objects/grass.png', hitbox: (24, 14)),
  tree (asset: 'objects/tree.png', hitbox: (22, 46));

  const CommonObjectAsset({
    required this.asset,
    required this.hitbox
  });

  final String asset;
  final (double x, double y) hitbox;

  static CommonObjectAsset getRandom() {
    return values[Random().nextInt(values.length)];
  }
}
