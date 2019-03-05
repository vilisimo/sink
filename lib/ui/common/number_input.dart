import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _controller;

  bool clearable = false;

  _ClearableNumberInputState(value)
      : _controller = value == null
            ? TextEditingController()
            : TextEditingController.fromValue(
                TextEditingValue(text: value.toString()),
              );

  @override
  void initState() {
    _controller.addListener(() => isClearable());
    _controller.addListener(() => handleChange());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleChange() {
    if (_controller.text != null && _controller.text != "") {
      widget.onChange(double.parse(_controller.text));
    }
  }

  void isClearable() {
    setState(() {
      clearable = _controller.text != null && _controller.text != "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [DecimalInputFormatter()],
      style: widget.style,
      decoration: InputDecoration(
        contentPadding: widget.contentPadding ?? EdgeInsets.all(16.0),
        hintText: widget.hintText,
        border: widget.border ?? InputBorder.none,
        isDense: true,
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          disabledColor: Colors.transparent,
          onPressed: clearable ? () => _controller.clear() : null,
        ),
      ),
    );
  }
}
