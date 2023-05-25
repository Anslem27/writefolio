import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedIconButton extends StatefulWidget {
  final Function()? onPressed;
  final Icon icon;

  const AnimatedIconButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedIconButtonState createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Widget> _floatingIcons = [];

  final List<Color> _iconColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.teal,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
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

  void _playHapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  void _addFloatingIcons() {
    setState(() {
      for (int i = 0; i < 8; i++) {
        _floatingIcons.add(_buildFloatingIcon());
      }
    });
  }

  Widget _buildFloatingIcon() {
    final random = Random();
    final size = random.nextDouble() * 30 + 10; // Random size between 10 and 40
    final xOffset =
        random.nextDouble() * 50 - 25; // Random x offset between -25 and 25
    final yOffset =
        random.nextDouble() * 100 - 50; // Random y offset between -50 and 50
    final color = _iconColors[random.nextInt(_iconColors.length)];

    return Positioned(
      top: 0,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(xOffset, yOffset - value * 100),
              child: Transform.scale(
                scale: size / 40,
                child: child,
              ),
            ),
          );
        },
        child: Icon(
          widget.icon.icon,
          color: color,
          size: widget.icon.size,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onPressed != null) {
          widget.onPressed!();
          _playHapticFeedback();
          _animationController.forward().then((_) {
            _animationController.reverse();
          });
          _addFloatingIcons();
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: child,
              );
            },
            child: widget.icon,
          ),
          ..._floatingIcons,
        ],
      ),
    );
  }
}
