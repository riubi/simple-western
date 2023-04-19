import 'package:flame/components.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/ui/clip_bar.dart';
import 'package:simple_western/ui/hp_bar.dart';

class PlayerBars extends PositionComponent {
  final Player player;

  PlayerBars(this.player, Vector2 position)
      : super(position: position, anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    var clipBar = ClipBar(player.gun, Vector2.zero());
    if (isFlippedHorizontally) {
      clipBar.flipHorizontally();
      clipBar.position.x += clipBar.size.x;
    }

    add(clipBar);
    add(HpBar(player, Vector2(20, 6)));
  }
}
