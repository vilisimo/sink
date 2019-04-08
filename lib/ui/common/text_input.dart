import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

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
  final _focus = new FocusNode();
  final _controller;

  bool clearable = false;
  bool focused = false;

  _TextInputState(value)
      : _controller = isBlank(value)
            ? TextEditingController()
            : TextEditingController.fromValue(TextEditingValue(text: value));

  @override
  void initState() {
    _controller.addListener(() => isClearable());
    _controller.addListener(() => widget.onChange(_controller.text));
    _focus.addListener(() => focused = !focused);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void isClearable() {
    setState(() {
      clearable = !isBlank(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
      style: widget.style,
      maxLines: widget.maxLines ?? 1,
      focusNode: _focus,
      decoration: InputDecoration(
        contentPadding: widget.contentPadding,
        hintText: widget.hintText,
        border: widget.border ?? OutlineInputBorder(),
        isDense: true,
        suffixIcon: focused
            ? IconButton(
                icon: Icon(Icons.clear),
                disabledColor: Colors.transparent,
                onPressed: clearable ? () => _controller.clear() : null,
              )
            : null,
      ),
    );
  }
}
