import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuBuilder {
  static Widget buildMenu(
    Map<String, void Function()> buttons, {
    String? title,
    Widget? header,
  }) {
    Widget widget = Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            children: buttons.entries
                .map((entry) => buildElement(entry.key, entry.value))
                .toList()));

    final List<Widget> list = [];

    if (title != null) {
      list.add(buildText(title, true));
    }

    if (header != null) {
      list.add(header);
    }

    if (list.isNotEmpty) {
      widget = Padding(
          padding: const EdgeInsets.all(40),
          child: Column(children: [...list, widget]));
    }

    return Center(child: widget);
  }

  static Widget buildElement(String text, void Function() onTap) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: buildText(text, false),
        ),
      );

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
      String? fontFamily = 'RaleWay',
      TextDecoration decoration = TextDecoration.none}) {
    return TextStyle(
      fontFamily: fontFamily,
      height: 1.6,
      decoration: decoration,
      decorationColor:
          isTitle ? const Color.fromRGBO(218, 77, 54, 0.9) : Colors.white,
      letterSpacing: 5,
      fontSize: fontSize,
      color: isTitle ? const Color.fromRGBO(218, 77, 54, 0.9) : Colors.white,
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
            throw Exception('Could not launch $url');
          }
        },
    );
  }
}
