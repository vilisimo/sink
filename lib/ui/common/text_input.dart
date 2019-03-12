import 'package:flutter/material.dart';
import 'package:sink/common/checks.dart';

class ClearableTextInput extends StatefulWidget {
  final Function(String) onChange;
  final String value;
  final String hintText;
  final TextStyle style;
  final int maxLines;
  final EdgeInsetsGeometry contentPadding;
  final InputBorder border;

  ClearableTextInput({
    @required this.onChange,
    @required this.hintText,
    this.value,
    this.style,
    this.maxLines,
    this.contentPadding,
    this.border,
  });

  @override
  State<StatefulWidget> createState() => _TextInputState(value);
}

class _TextInputState extends State<ClearableTextInput> {
  final _controller;
  bool clearable = false;

  _TextInputState(value)
      : _controller = isEmpty(value)
            ? TextEditingController()
            : TextEditingController.fromValue(TextEditingValue(text: value));

  @override
  void initState() {
    _controller.addListener(() => isClearable());
    _controller.addListener(() => widget.onChange(_controller.text));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void isClearable() {
    setState(() {
      clearable = !isEmpty(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      controller: _controller,
      style: widget.style,
      maxLines: widget.maxLines ?? 1,
      decoration: InputDecoration(
        contentPadding: widget.contentPadding,
        hintText: widget.hintText,
        border: widget.border ?? OutlineInputBorder(),
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
