import 'dart:math';
import 'package:audioplayers/src/audioplayer.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static const String bulletAudio1 = 'bullet-1.mp3';
  static const String bulletAudio2 = 'bullet-2.mp3';
  static const String bulletAudio3 = 'bullet-3.mp3';
  static const String bulletDelivery = 'bullet-delivery.mp3';

  static const String manDeath = 'man-death.mp3';
  static const String matchAudio = 'match.mp3';
  static const String lobbyAudio = 'lobby.mp3';

  static preload() async {
    await FlameAudio.audioCache.loadAll([
      bulletAudio1,
      bulletAudio2,
      bulletAudio3,
      bulletDelivery,
      matchAudio,
      lobbyAudio
    ]);
  }

  static void playBulletShot() {
    playAudio([bulletAudio1, bulletAudio2, bulletAudio3]
        .elementAt(Random().nextInt(3)));
  }

  static Future<AudioPlayer> playAudio(String name, {double volume = 1}) {
    return FlameAudio.playLongAudio(name, volume: volume);
  }
}
