// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class DeepPulseAnimation extends StatefulWidget {
  const DeepPulseAnimation({Key? key}) : super(key: key);

  @override
  _DeepPulseAnimationState createState() => _DeepPulseAnimationState();
}

class _DeepPulseAnimationState extends State<DeepPulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: 350,
        height: 350,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
