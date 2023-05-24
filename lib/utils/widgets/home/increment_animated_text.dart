// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class IncrementAnimatedText extends StatefulWidget {
  final int value;
  final TextStyle? textStyle;
  final Duration duration;

  const IncrementAnimatedText({
    Key? key,
    required this.value,
    this.textStyle,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _IncrementAnimatedTextState createState() => _IncrementAnimatedTextState();
}

class _IncrementAnimatedTextState extends State<IncrementAnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(IncrementAnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _previousValue) {
      _animationController.reset();
      _animationController.forward();
      _previousValue = widget.value;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _animation.value * 2 * 3.14159265359, // Rotate 2π radians (360 degrees)
      child: Text(
        "${widget.value}",
        style: widget.textStyle,
      ),
    );
  }
}
