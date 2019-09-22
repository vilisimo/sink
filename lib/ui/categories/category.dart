import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final Icon icon;
  final Color color;

  CategoryIcon._internal(this.icon, this.color);

  factory CategoryIcon({
    @required IconData iconData,
    @required Color color,
    bool isActive,
  }) {
    var active = isActive ?? false;
    var finalIcon = Icon(iconData, color: active ? Colors.white : Colors.black);
    var finalColor = active
        ? Color.fromRGBO(color.red, color.green, color.blue, .8)
        : Color.fromRGBO(color.red, color.green, color.blue, .7);

    return CategoryIcon._internal(finalIcon, finalColor);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: icon,
      ),
    );
  }
}
