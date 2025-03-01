import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_western/config/audio_set.dart';
import 'package:simple_western/interface/interface_builder.dart';
import 'package:simple_western/screens/guide_screen.dart';
import 'package:simple_western/screens/splash_screen.dart';

enum GameMode { pvp, pve, battle }

class Menu extends Component with HasGameRef, KeyboardHandler {
  final List<Map<String, String>> _authLinks = [
    {'label': 'LinkedIn', 'url': 'https://www.linkedin.com/in/ruslan-papina/'},
    {'label': 'Github', 'url': 'https://github.com/riubi/simple_western'},
  ];

  final List<Map<String, String>> _assetsLinks = [
    {'label': '@dara90', 'url': 'https://www.fiverr.com/dara90'},
    {'label': '@surajrenuka', 'url': 'https://www.fiverr.com/surajrenuka'},
  ];

  static const lobbyAsset = 'assets/images/ui/logo.png';
  static const creditsAsset = 'assets/images/ui/credits.gif';
  static const double creditsWidth = 700.0;
  static const double creditsPadding = 60.0;
  static const double contactFontSize = 18.0;

  final void Function() _pvpInit;
  final void Function() _pveInit;
  final void Function() _teamBattleInit;
  final void Function() _gameStop;

  bool _guideSeen = false;
  bool _isMenuHiddable = false;

  Menu(this._pvpInit, this._pveInit, this._teamBattleInit, this._gameStop);

  @override
  FutureOr<void> onLoad() {
    final overlays = {
      'LobbyMenu': _lobbyMenuBuilder,
      'PauseMenu': _pauseMenuBuilder,
      'GameOver': _gameOverMenuBuilder,
      'Options': _optionsMenuBuilder,
      'Credits': _creditsMenuBuilder,
      'GuideScreen': _controlGuideBuilder,
      'IntroScreen': _introBuilder,
    };

    overlays.forEach((key, builder) => gameRef.overlays.addEntry(key, builder));

    _openOverlay('IntroScreen');

    return super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      toggleMenu();
    }
    return true;
  }

  void _startGame(GameMode mode) {
    _isMenuHiddable = true;
    _closeOverlay();

    switch (mode) {
      case GameMode.pvp:
        _pvpInit();
        break;
      case GameMode.pve:
        _pveInit();
        break;
      case GameMode.battle:
        _teamBattleInit();
        break;
    }

    gameRef.resumeEngine();

    if (!_guideSeen) {
      _guideSeen = true;
      _openOverlay('GuideScreen');
    }
  }

  void _openOverlay(String overlay) {
    gameRef.overlays.clear();
    gameRef.overlays.add(overlay);
    gameRef.pauseEngine();
  }

  void _closeOverlay() {
    gameRef.overlays.clear();
    gameRef.resumeEngine();
  }

  void toggleMenu() {
    if (!_isMenuHiddable) return;
    gameRef.overlays.isActive('PauseMenu')
        ? _closeOverlay()
        : _openOverlay('PauseMenu');
  }

  void onIntroTap() {
    openLobbyMenu();
    AudioSet.playIntro();
  }

  void openLobbyMenu() {
    _isMenuHiddable = false;
    _gameStop();
    _openOverlay('LobbyMenu');
    gameRef.resumeEngine();
  }

  void openEndGameMenu() {
    _isMenuHiddable = false;
    _openOverlay('GameOver');
  }

  Map<String, VoidCallback> _baseMenuButtons() => {
        'Duel vs Bot': () => _startGame(GameMode.pve),
        'Players Duel': () => _startGame(GameMode.pvp),
        'Team Showdown': () => _startGame(GameMode.battle),
      };

  Widget _introBuilder(BuildContext context, Game game) =>
      SplashScreen(onDismiss: onIntroTap).build(context);

  Widget _lobbyMenuBuilder(BuildContext context, Game game) =>
      InterfaceBuilder.buildMenu(
        _baseMenuButtons()
          ..addAll({
            'OPTIONS': _menuSwitcher('Options'),
            'CREDITS': _menuSwitcher('Credits')
          }),
        header: Image.asset(lobbyAsset, width: 600),
      );

  Widget _pauseMenuBuilder(BuildContext context, Game game) =>
      InterfaceBuilder.buildMenu(
        _baseMenuButtons()
          ..addAll({
            'Control Guide': _menuSwitcher('GuideScreen'),
            'TO LOBBY': openLobbyMenu
          }),
        title: 'PAUSED',
      );

  Widget _gameOverMenuBuilder(BuildContext context, Game game) =>
      InterfaceBuilder.buildMenu(
        _baseMenuButtons()..addAll({'TO LOBBY': openLobbyMenu}),
        title: 'Game Over',
      );

  Widget _optionsMenuBuilder(BuildContext context, Game game) {
    String audioSwitcher =
        AudioSet.isEnabled() ? 'DISABLE AUDIO' : 'ENABLE AUDIO';

    return InterfaceBuilder.buildMenu({
      audioSwitcher: () {
        AudioSet.toggle();
        _openOverlay('Options');
      },
      'BACK': _menuSwitcher('LobbyMenu'),
    }, title: 'OPTIONS');
  }

  Widget _creditsMenuBuilder(BuildContext context, Game game) =>
      InterfaceBuilder.buildMenu(
        {'BACK': _menuSwitcher('LobbyMenu')},
        title: 'CREDITS',
        header: Column(
          textDirection: TextDirection.ltr,
          children: [
            Padding(
              padding: const EdgeInsets.all(creditsPadding),
              child: Image.asset(creditsAsset, width: creditsWidth),
            ),
            _prepareCreditsText(),
          ],
        ),
      );

  Widget _controlGuideBuilder(BuildContext context, Game game) =>
      GuideScreen(() {
        game.overlays.clear();
        game.resumeEngine();
      }).build(context);

  Text _prepareCreditsText() => Text.rich(
        TextSpan(
          text: '',
          style: InterfaceBuilder.buildStyle(false,
              fontSize: contactFontSize, fontFamily: null),
          children: [
            const TextSpan(text: 'Created by: Papina Ruslan\n'),
            _buildLinkText('Contacts: clu@tut.by, ', _authLinks),
            const TextSpan(text: '\n'),
            _buildLinkText('Assets created by: ', _assetsLinks),
          ],
        ),
      );

  void Function() _menuSwitcher(String title) => () => _openOverlay(title);

  TextSpan _buildLinkText(String title, List<Map<String, String>> mapLinks) {
    List<TextSpan> links = [];

    for (var i = 0; i < mapLinks.length; i++) {
      links.add(InterfaceBuilder.buildUrl(
          mapLinks[i]['label']!, mapLinks[i]['url']!));

      if (i != mapLinks.length - 1) {
        links.add(const TextSpan(text: ', '));
      }
    }

    return TextSpan(
      text: title,
      children: links,
    );
  }
}
