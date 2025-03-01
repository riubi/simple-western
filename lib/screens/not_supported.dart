import 'package:flutter/material.dart';
import 'package:simple_western/interface/interface_builder.dart';

class NotSupported extends StatelessWidget {
  const NotSupported({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: InterfaceBuilder.buildText(
                  'This game is not supported on mobile devices.\n\nTry opening it on a PC!',
                  false,
                  fontSize: 24,
                  align: TextAlign.center)),
        )));
  }
}
