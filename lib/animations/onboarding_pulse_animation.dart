// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class OnboardingPulseAnimation extends StatefulWidget {
  const OnboardingPulseAnimation({Key? key}) : super(key: key);

  @override
  _OnboardingPulseAnimationState createState() =>
      _OnboardingPulseAnimationState();
}

class _OnboardingPulseAnimationState extends State<OnboardingPulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation =
        Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: Image.asset("assets/images/Grad.png"),
    );
  }
}
