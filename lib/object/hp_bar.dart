import 'dart:async';
import 'package:flame/components.dart';
import 'package:simple_western/object/player.dart';

class HpBar extends Component {
  static const fullHp = 'ui/full-hp.png';
  static const noHp = 'ui/no-hp.png';

  late int hp;
  final Vector2 position;
  final Anchor anchor;

  late final Sprite _fullHpSprite;
  late final Sprite _noHpSprite;

  final List<SpriteComponent> sprites = [];

  HpBar(Player player, this.position, this.anchor) {
    hp = player.hp;
    player.onDamage = _onDamage;
  }

  @override
  FutureOr<void> onLoad() async {
    _fullHpSprite = await Sprite.load(fullHp);
    _noHpSprite = await Sprite.load(noHp);

    for (int i = 0; i < hp; i++) {
      sprites.add(SpriteComponent(
          sprite: _fullHpSprite,
          size: Vector2.all(18),
          position: Vector2(position.x + i * 22, position.y),
          anchor: anchor));
    }

    await addAll(sprites);

    return super.onLoad();
  }

  _onDamage(int hp) {
    sprites[hp].sprite = _noHpSprite;
  }
}
