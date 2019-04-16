import 'package:flutter/material.dart';

class ColoredDot extends StatelessWidget {
  final double radius;
  final Color color;
  final EdgeInsets padding;

  ColoredDot({
    @required this.radius,
    @required this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
      child: Container(
        height: radius * 2,
        width: radius * 2,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}
