import 'package:flutter/material.dart';
import 'package:sink/theme/palette.dart' as Palette;

class RoundedButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final BorderRadius radius;
  final Color buttonColor;

  RoundedButton({
    @required this.onPressed,
    @required this.text,
    radius,
    buttonColor,
  })  : this.radius = radius ?? BorderRadius.circular(5.0),
        this.buttonColor = buttonColor ?? Colors.lightGreen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: radius),
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Colors.white)),
        disabledColor: Colors.grey,
        color: buttonColor,
        onPressed: onPressed != null ? () => onPressed() : null,
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  final BorderRadius radius;
  final Color buttonColor;

  LoadingButton({radius, buttonColor})
      : this.radius = radius ?? BorderRadius.circular(5.0),
        this.buttonColor = buttonColor ?? Colors.lightGreen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: radius),
        child: SizedBox(
          width: 16.0,
          height: 16.0,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
          ),
        ),
        color: buttonColor,
        disabledColor: Palette.disabled,
        onPressed: null,
      ),
    );
  }
}
