import 'package:flutter/material.dart';

class ColorGrid extends StatefulWidget {
  final List<Color> colors;
  final Function(Color) onTap;

  ColorGrid({@required this.colors, @required this.onTap});

  @override
  ColorGridState createState() => ColorGridState(colors, onTap);
}

class ColorGridState extends State<StatefulWidget> {
  List<Color> _colors;
  Color _selectedColor;
  Function(Color) _onTap;

  ColorGridState(this._colors, this._onTap) : _selectedColor = _colors[0];

  void _handleTap(Color newColor) {
    _onTap(newColor);

    setState(() {
      _selectedColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: GridView.count(
          shrinkWrap: true,
          primary: true,
          physics: BouncingScrollPhysics(),
          crossAxisCount: 5,
          children: _colors.map((color) {
            return Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: ColorButton(color, _selectedColor == color, _handleTap),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  static const SELECTED_OPACITY = 1.0;
  static const UNSELECTED_OPACITY = 0.6;

  final Color _color;
  final bool _isSelected;
  final Function(Color) _onTap;

  ColorButton(this._color, this._isSelected, this._onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(
              _color.red,
              _color.green,
              _color.blue,
              _isSelected ? SELECTED_OPACITY : UNSELECTED_OPACITY,
            ),
          ),
          child: _isSelected ? Icon(Icons.check) : null,
        ),
      ),
      onTap: () => _onTap(_color),
    );
  }
}
