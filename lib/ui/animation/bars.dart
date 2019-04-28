import 'package:flutter/material.dart';

class AnimatedBar extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final bool horizontal;
  final BorderRadiusGeometry borderRadius;
  final Duration duration;

  AnimatedBar({
    @required this.width,
    @required this.height,
    @required this.color,
    horizontal,
    borderRadius,
    duration,
  })  : this.horizontal = horizontal ?? false,
        this.borderRadius = borderRadius,
        this.duration = duration ?? const Duration(milliseconds: 350);

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
      duration: widget.duration,
      vsync: this,
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var fraction = _controller.value;
    return Container(
      width: widget.horizontal ? widget.width * fraction : widget.width,
      height: widget.horizontal ? widget.height : widget.height * fraction,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        color: widget.color,
      ),
    );
  }
}
