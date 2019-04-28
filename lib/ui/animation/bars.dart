import 'package:flutter/material.dart';

class AnimatedHorizontalBar extends StatefulWidget {
  final Color color;
  final double percentOfScreen;

  AnimatedHorizontalBar({
    @required this.color,
    @required this.percentOfScreen,
  });

  @override
  State<StatefulWidget> createState() => _AnimatedHorizontalBarState();
}

class _AnimatedHorizontalBarState extends State<AnimatedHorizontalBar>
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

class AnimatedVerticalBar extends StatefulWidget {
  final Color color;
  final double height;
  final double width;

  AnimatedVerticalBar({
    @required this.color,
    @required this.height,
    @required this.width,
  });

  @override
  State<StatefulWidget> createState() => AnimatedVerticalBarState();
}

class AnimatedVerticalBarState extends State<AnimatedVerticalBar>
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
    final double heightFraction = _controller.value;
    return Container(
      width: widget.width,
      height: widget.height * heightFraction,
      decoration: BoxDecoration(
        color: widget.color,
      ),
    );
  }
}
