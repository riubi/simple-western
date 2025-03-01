import 'package:flutter/material.dart';
import 'package:simple_western/interface/interface_builder.dart';

class GuideScreen extends StatelessWidget {
  final VoidCallback onDismiss;
  static const double _spacing = 160;

  const GuideScreen(this.onDismiss, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InterfaceBuilder.buildMenu({},
          title: 'Control Guide',
          textContent: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: _spacing,
              children: [
                _buildPlayerGuide(
                    'Player 1', 'W,A,S,D - Move\nSpace - Shoot\nR - Reload'),
                _buildPlayerGuide(
                    'Player 2', 'Arrows - Move\nShift - Shoot\nEnter - Reload'),
              ],
            ),
            const SizedBox(height: _spacing / 2),
            InterfaceBuilder.buildKeySkipWidget(onDismiss),
          ]),
    ]);
  }

  Widget _buildPlayerGuide(String player, String controls) {
    return Column(
      children: [
        InterfaceBuilder.buildText(player, true, fontSize: 32),
        const SizedBox(height: 20),
        InterfaceBuilder.buildText(controls, false, fontSize: 26),
      ],
    );
  }
}
