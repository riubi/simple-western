import 'package:flame/components.dart';
import 'package:simple_western/behavioral/controllable.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/entity/bullet.dart';

class Gun extends Component {
  static const _defaultClipSize = 5;

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

    var controllableParent = parent as Controllable;
    parent!.add(Bullet(controllableParent.isTurnRight() ? 1 : -1, _ignoreList));

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
