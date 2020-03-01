import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sink/redux/selectors.dart';
import 'package:sink/redux/state.dart';

class ColorGrid extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onTap;

  ColorGrid({@required this.selectedColor, @required this.onTap});

  void _handleTap(Color newColor) {
    onTap(newColor);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromState,
      builder: (BuildContext context, _ViewModel vm) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Scrollbar(
            child: GridView.count(
              shrinkWrap: true,
              primary: true,
              physics: BouncingScrollPhysics(),
              crossAxisCount: 5,
              children: vm.colors.map((color) {
                return Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: ColorButton(
                    color,
                    this.selectedColor == color,
                    _handleTap,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final Set<Color> colors;

  _ViewModel({@required this.colors});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      colors: getAvailableColors(store.state),
    );
  }
}

class ColorButton extends StatelessWidget {
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
              1.0,
            ),
          ),
          child: _isSelected ? Icon(Icons.check) : null,
        ),
      ),
      onTap: () => _onTap(_color),
    );
  }
}
