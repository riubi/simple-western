import 'package:flame/components.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/object/bullet.dart';

class Gun extends Component {
  static const _defaultClipSize = 6;

  final Set<PositionComponent> _ignoreList;
  final List<void Function(int)> _handlers = [];

  int bulletCounts = _defaultClipSize;

  Gun(this._ignoreList);

  bool reload() {
    if (bulletCounts >= _defaultClipSize) {
      return false;
    }

    AudioSet.play(AudioSet.gunReload);

    bulletCounts++;

    _handleCallbacks();

    return true;
  }

  bool preShoot() {
    AudioSet.play(AudioSet.gunTrigger);

    return true;
  }

  bool shoot() {
    if (bulletCounts <= 0) {
      AudioSet.play(AudioSet.gunEmptyClip);
      return false;
    }

    AudioSet.playBulletShot();

    bulletCounts--;

    _handleCallbacks();

    var positionParent = parent as PositionComponent;
    var isTurnedLeft = positionParent.anchor.x == Anchor.centerLeft.x;

    parent!.add(Bullet(isTurnedLeft ? 1 : -1, _ignoreList));

    return true;
  }

  void addClipHandler(void Function(int) onUpdate) {
    _handlers.add(onUpdate);
  }

  void _handleCallbacks() {
    for (final handler in _handlers) {
      handler(bulletCounts);
    }
  }
}
