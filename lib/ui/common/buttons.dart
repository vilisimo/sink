import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final BorderRadius radius;
  final TextStyle textStyle;
  final Color buttonColor;

  RoundedButton({
    @required this.onPressed,
    @required this.text,
    radius,
    buttonColor,
    textStyle,
  })  : this.radius = radius ?? BorderRadius.circular(5.0),
        this.buttonColor = buttonColor ?? Colors.lightGreen,
        this.textStyle = textStyle ??
            TextStyle(
              fontSize: 16.0,
              letterSpacing: .65,
              color: Colors.white,
            );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: radius),
        child: Text(text, style: textStyle),
        color: buttonColor,
        onPressed: () => onPressed(),
      ),
    );
  }
}
