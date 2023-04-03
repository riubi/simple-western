import 'package:flame/components.dart';
import 'package:flame/events.dart';

class MenuElement extends TextComponent with Tappable {
  final Function() tapCallback;
  MenuElement(text, this.tapCallback) : super(text: text);

  @override
  bool onTapDown(TapDownInfo event) {
    tapCallback();
    return true;
  }
}
