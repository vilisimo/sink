import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/strings.dart';
import 'package:sink/common/input_formatter.dart';

class ClearableNumberInput extends StatefulWidget {
  final Function(double) onChange;
  final double value;
  final String hintText;
  final TextStyle style;
  final EdgeInsetsGeometry contentPadding;
  final InputBorder border;

  ClearableNumberInput({
    @required this.onChange,
    @required this.value,
    @required this.hintText,
    this.style,
    this.contentPadding,
    this.border,
  });

  @override
  State<StatefulWidget> createState() => _ClearableNumberInputState(value);
}

class _ClearableNumberInputState extends State<ClearableNumberInput> {
  final _focus = FocusNode();
  final _controller;

  bool focused = false;

  _ClearableNumberInputState(value)
      : _controller = value == null
            ? TextEditingController()
            : TextEditingController.fromValue(
                TextEditingValue(text: value.toString()),
              );

  @override
  void initState() {
    _controller.addListener(() => handleChange());
    _focus.addListener(() => focused = !focused);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleChange() {
    var number = _controller.text;
    widget.onChange(isBlank(number) ? null : double.parse(number));
  }

  bool isClearable() {
    return !isBlank(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [DecimalInputFormatter()],
      style: widget.style,
      focusNode: _focus,
      decoration: InputDecoration(
        contentPadding: widget.contentPadding ?? EdgeInsets.all(16.0),
        hintText: widget.hintText,
        border: widget.border ?? InputBorder.none,
        isDense: true,
        suffixIcon: focused
            ? IconButton(
                icon: Icon(Icons.clear),
                disabledColor: Colors.transparent,
                onPressed: isClearable() ? () => _controller.clear() : null,
              )
            : null,
      ),
    );
  }
}
