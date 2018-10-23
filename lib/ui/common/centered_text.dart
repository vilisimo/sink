import 'package:flutter/material.dart';

class CenteredText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  CenteredText({@required this.text, fontSize, fontWeight})
      : this.fontSize = fontSize ?? 16.0,
        this.fontWeight = fontWeight ?? FontWeight.normal;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
