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
  static const intro = 'intro.mp3';

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

  static void preloadAndPlayIntro() async {
    await FlameAudio.audioCache.load(intro);
    playIntroAudio();
  }

  static void playMatchAudio() {
    _bgmPlay(match, .45);
  }

  static void playIntroAudio() {
    _bgmPlay(intro, .55);
  }

  static void playLobbyAudio() {
    _bgmPlay(lobby, .25);
  }

  static void playBulletShot() {
    play([bulletAudio1, bulletAudio2, bulletAudio3]
        .elementAt(Random().nextInt(3)));
  }

  static Future<AudioPlayer> play(String name, {double volume = 0.8}) {
    return FlameAudio.playLongAudio(name, volume: volume);
  }

  static void _bgmPlay(String match, double volume) {
    if (FlameAudio.bgm.isPlaying) {
      FlameAudio.bgm.stop();
    }
    FlameAudio.bgm.play(match, volume: .45);
  }
}
