import 'package:flutter/material.dart';

class ClearableTextInput extends StatefulWidget {
  final String hintText;
  final Function(String) onChange;

  ClearableTextInput({@required this.hintText, @required this.onChange});

  @override
  State<StatefulWidget> createState() => _TextInputState(hintText, onChange);
}

class _TextInputState extends State<ClearableTextInput> {
  final _controller = TextEditingController();
  bool clearable = false;

  final String hintText;
  Function(String) onChange;

  _TextInputState(this.hintText, this.onChange);

  @override
  void initState() {
    _controller.addListener(() => isClearable());
    _controller.addListener(() => onChange(_controller.text));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void isClearable() {
    setState(() {
      clearable = _controller.text != null && _controller.text != "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      controller: _controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
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
