import 'package:flame/components.dart';
import 'package:simple_western/object/player.dart';
import 'package:simple_western/ui/clip_bar.dart';
import 'package:simple_western/ui/hp_bar.dart';
import 'package:simple_western/ui/menu_builder.dart';

class PlayerBars extends PositionComponent {
  final Player player;

  PlayerBars(this.player, Vector2 position)
      : super(position: position, anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    position = Vector2(6 - player.size.x / 2, -14);

    var clipBar = ClipBar(player.gun)
      ..position.x += 3
      ..position.y -= 4;

    var hpBar = HpBar(player);

    var playerLabel = TextComponent(
      text: player.label,
      priority: 100,
      textRenderer: TextPaint(
        style: MenuBuilder.buildStyle(false, fontSize: 12, letterSpacing: 0),
      ),
    )
      ..position = Vector2(-1, -12)
      ..anchor = Anchor.topRight;

    addAll([playerLabel, hpBar, clipBar]);

    player.addEliminatingHandler(() => removeFromParent());
  }
}
