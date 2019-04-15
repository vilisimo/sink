import 'package:flutter/material.dart';

class AnimatedBar extends StatefulWidget {
  final Color color;
  final double percentOfScreen;

  AnimatedBar({
    @required this.color,
    @required this.percentOfScreen,
  });

  @override
  State<StatefulWidget> createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<AnimatedBar>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.forward().orCancel;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = _controller.value;
    return Container(
      width: MediaQuery.of(context).size.width * widget.percentOfScreen * width,
      height: 20.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: widget.color,
      ),
    );
  }
}
