import 'package:flutter/material.dart';

class ColorGrid extends StatefulWidget {
  final List<Color> _colors;

  ColorGrid(this._colors);

  @override
  ColorGridState createState() {
    return ColorGridState(_colors);
  }
}

class ColorGridState extends State<StatefulWidget> {
  List<Color> _colors;
  Color _selectedColor;

  ColorGridState(this._colors) : _selectedColor = _colors[0];

  void _handleTap(Color _selectedColor) {
    setState(() {
      this._selectedColor = _selectedColor;
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
  final Color _color;
  final bool _isSelected;
  final Function(Color) _handleTap;

  ColorButton(this._color, this._isSelected, this._handleTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(
                _color.red, _color.green, _color.blue, _isSelected ? 1.0 : 0.6),
          ),
          child: _isSelected ? Icon(Icons.check) : null,
        ),
      ),
      onTap: () => _handleTap(_color),
    );
  }
}
