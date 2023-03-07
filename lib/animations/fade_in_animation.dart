import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FloatInAnimation extends StatelessWidget {
  final Widget child;
  final double delay;
  const FloatInAnimation({Key? key, required this.child, required this.delay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* final tween = MovieTween()
      ..tween(
        'opacity',
        Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
      ).thenTween(
        'translateY',
        Tween(begin: -30.0, end: 0.0),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      ); */

    // plays an animation once
    return PlayAnimationBuilder<double>(
      delay: Duration(milliseconds: (500 * delay).round()),
      tween: Tween(begin: 0, end: 1), // from 0 to 1
      duration: const Duration(milliseconds: 2000), // 1.5 seconds
      curve: Curves.easeOutQuint, // easing curve for smooth animation
      builder: (context, value, _) {
        final offset = Offset(0, 100 - (100 * value));
        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
    );
  }
}
