import 'dart:math';
import 'package:audioplayers/src/audioplayer.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioSet {
  static const bulletAudio1 = 'bullet-1.mp3';
  static const bulletAudio2 = 'bullet-2.mp3';
  static const bulletAudio3 = 'bullet-3.mp3';
  static const bulletDelivery = 'bullet-delivery.mp3';

  static const manDeath = 'man-death.mp3';
  static const match = 'match.mp3';
  static const lobby = 'lobby.mp3';

  static preload() async {
    await FlameAudio.audioCache.loadAll([
      match,
      lobby,
      bulletAudio1,
      bulletAudio2,
      bulletAudio3,
      bulletDelivery,
      manDeath,
    ]);
  }

  static void playMatchAudio() {
    FlameAudio.bgm.play(match, volume: .3);
  }

  static void playLobbyAudio() {
    FlameAudio.bgm.play(lobby, volume: .4);
  }

  static void playBulletShot() {
    play([bulletAudio1, bulletAudio2, bulletAudio3]
        .elementAt(Random().nextInt(3)));
  }

  static Future<AudioPlayer> play(String name, {double volume = 1}) {
    return FlameAudio.playLongAudio(name, volume: volume);
  }
}
