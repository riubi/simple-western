import 'dart:math';

import 'package:flame_audio/flame_audio.dart';

class AudioSet {
  static const bulletAudio1 = 'bullet-1.mp3';
  static const bulletAudio2 = 'bullet-2.mp3';
  static const bulletAudio3 = 'bullet-3.mp3';
  static const bulletAudio4 = 'bullet-4.mp3';
  static const bulletDelivery = 'bullet-delivery.mp3';
  static const gunTrigger = 'gun-trigger.mp3';
  static const gunReload = 'gun-reload.mp3';
  static const gunEmptyClip = 'gun-empty-clip.mp3';
  static const manDeath = 'man-death.mp3';

  static const audioAssets = [
    manDeath,
    bulletAudio1,
    bulletAudio2,
    bulletAudio3,
    bulletAudio4,
    bulletDelivery,
    gunEmptyClip,
    gunTrigger,
    gunReload,
  ];

  static const introVolume = .55;
  static const matchVolume = .30;
  static const lobbyVolume = .28;
  static const defaultVolume = .65;

  static final bulletsAudio = [
    bulletAudio1,
    bulletAudio2,
    bulletAudio3,
    bulletAudio4
  ];

  static final Map<String, AudioPool> audioPool = {};

  static const match = 'match.mp3';
  static const lobby = 'lobby.mp3';
  static const intro = 'intro.mp3';

  static bool _audioEnabled = true;

  static Future<void> preload() async {
    await FlameAudio.audioCache.loadAll(audioAssets);
    await FlameAudio.audioCache.loadAll([match, lobby, intro]);

    for (final soundName in audioAssets) {
      createPool(soundName).then((pool) => audioPool[soundName] = pool);
    }
  }

  static Future<AudioPool> createPool(String soundName) {
    return FlameAudio.createPool(soundName, maxPlayers: 5, minPlayers: 2);
  }

  static void playIntro() async {
    playIntroAudio();
  }

  static void playMatchAudio() {
    _bgmPlay(match, matchVolume);
  }

  static void playIntroAudio() {
    _bgmPlay(intro, introVolume);
  }

  static void playLobbyAudio() {
    _bgmPlay(lobby, lobbyVolume);
  }

  static void playBulletShot() {
    var randomIndex = Random().nextInt(bulletsAudio.length * 2);
    if (randomIndex >= bulletsAudio.length) {
      randomIndex = bulletsAudio.length - 1;
    }
    play(bulletsAudio[randomIndex]);
  }

  static void play(String soundName, {double volume = defaultVolume}) {
    if (!_audioEnabled) {
      return;
    }

    audioPool[soundName]!.start(volume: volume);
  }

  static void _bgmPlay(String match, double volume) {
    if (!_audioEnabled) {
      return;
    }

    if (FlameAudio.bgm.isPlaying) {
      FlameAudio.bgm.stop();
    }
    FlameAudio.bgm.play(match, volume: volume);
  }

  static bool isEnabled() {
    return _audioEnabled;
  }

  static void disable() {
    FlameAudio.bgm.stop();
    _audioEnabled = false;
  }

  static void enable() {
    _audioEnabled = true;
  }

  static void toggle() {
    isEnabled() ? disable() : enable();
  }
}
