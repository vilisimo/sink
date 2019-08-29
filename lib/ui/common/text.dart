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

class FormTitleText extends StatelessWidget {
  final String text;

  FormTitleText({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.body2,
      ),
    );
  }
}
