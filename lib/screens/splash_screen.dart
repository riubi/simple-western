import 'package:flutter/material.dart';
import 'package:simple_western/interface/interface_builder.dart';

class SplashScreen extends StatelessWidget {
  final VoidCallback onDismiss;

  const SplashScreen({required this.onDismiss, super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/ui/logo.png', width: 650, height: 96),
            const SizedBox(height: 50),
            InterfaceBuilder.buildKeySkipWidget(onDismiss),
          ],
        ),
      );
}
