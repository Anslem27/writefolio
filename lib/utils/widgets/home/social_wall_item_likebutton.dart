import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WallComponentLikeButton extends StatefulWidget {
  final Function()? ontap;
  final bool isLiked;

  const WallComponentLikeButton({
    Key? key,
    this.ontap,
    required this.isLiked,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WallComponentLikeButtonState createState() =>
      _WallComponentLikeButtonState();
}

class _WallComponentLikeButtonState extends State<WallComponentLikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Widget> _floatingHearts = [];

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

  void _addFloatingHeart() {
    setState(() {
      _floatingHearts.add(_buildFloatingHeart());
    });
  }

  Widget _buildFloatingHeart() {
    final random = Random();
    final size = random.nextDouble() * 30 + 10; // Random size between 10 and 40
    final xOffset =
        random.nextDouble() * 50 - 25; // Random x offset between -25 and 25
    final yOffset =
        random.nextDouble() * 100 - 50; // Random y offset between -50 and 50

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
          Icons.favorite,
          color: Colors.red[800],
          size: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.ontap != null) {
          widget.ontap!();
          _playHapticFeedback();
          _animationController.forward().then((_) {
            _animationController.reverse();
          });
          _addFloatingHeart();
        }
      },
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: child,
              );
            },
            child: widget.isLiked
                ? Icon(
                    Icons.favorite,
                    color: Colors.red[800],
                  )
                : const Icon(Icons.favorite_outline),
          ),
          ..._floatingHearts,
        ],
      ),
    );
  }
}
