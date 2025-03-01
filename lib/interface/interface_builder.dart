import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class InterfaceBuilder {
  static Widget buildMenu(
    Map<String, void Function()> buttons, {
    String? title,
    Widget? header,
    List<Widget>? textContent,
  }) {
    List<Widget> elements = [];

    if (title != null) {
      elements.add(buildText(title, true));
    }

    if (header != null) {
      elements.add(header);
    }

    if (textContent != null) {
      elements.addAll(textContent);
    }

    if (buttons.isNotEmpty) {
      elements.add(Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: buttons.entries
              .map((entry) => buildOnTapText(entry.key, entry.value))
              .toList(),
        ),
      ));
    }

    return Center(
        child: Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: elements,
      ),
    ));
  }

  static Widget buildOnTapText(String text, void Function() onTap) =>
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: buildText(text, false),
        ),
      );

  static Widget buildKeySkipWidget(VoidCallback onKeyPress) => KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          onKeyPress();
        }
      },
      child: InterfaceBuilder.buildText('<Press any key to continue>', true,
          fontSize: 32));

  static Text buildText(String text, bool isTitle,
      {double? fontSize, TextAlign? align}) {
    return Text(
      text,
      textAlign: align,
      style: buildStyle(isTitle, fontSize: fontSize),
    );
  }

  static Text buildSmallText(String text) {
    return buildText(text, false, fontSize: 22);
  }

  static TextStyle buildStyle(bool isTitle,
      {double? fontSize,
      lineHeight = 1.6,
      double? height = 1.6,
      double? letterSpacing = 5,
      String? fontFamily = 'RaleWay',
      TextDecoration decoration = TextDecoration.none}) {
    return TextStyle(
      fontFamily: fontFamily,
      height: height,
      decoration: decoration,
      decorationColor:
          isTitle ? const Color.fromRGBO(218, 77, 54, 0.9) : Colors.white,
      letterSpacing: letterSpacing,
      fontSize: fontSize,
      color: isTitle ? const Color.fromRGBO(218, 77, 54, 0.9) : Colors.white,
      shadows: [
        Shadow(offset: Offset(1, 1), blurRadius: 2, color: Color(0xFF000000))
      ],
    );
  }

  static TextSpan buildUrl(String text, String link, {String? fontFamily}) {
    return TextSpan(
      text: text,
      style: buildStyle(true, fontFamily: fontFamily),
      mouseCursor: SystemMouseCursors.click,
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          var url = Uri.parse(link);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            debugPrint('Could not launch $url');
          }
        },
    );
  }
}
