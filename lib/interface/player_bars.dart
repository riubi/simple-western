import 'package:flame/components.dart';
import 'package:simple_western/entity/player.dart';
import 'package:simple_western/interface/clip_bar.dart';
import 'package:simple_western/interface/hp_bar.dart';
import 'package:simple_western/interface/interface_builder.dart';

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
        style:
            InterfaceBuilder.buildStyle(false, fontSize: 12, letterSpacing: 0),
      ),
    )
      ..position = Vector2(-2, -12)
      ..anchor = Anchor.topRight;

    player.addEliminatingHandler(() => removeFromParent());

    await addAll([playerLabel, hpBar, clipBar]);

    return super.onLoad();
  }
}
