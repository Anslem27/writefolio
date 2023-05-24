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
  _WallComponentLikeButtonState createState() =>
      _WallComponentLikeButtonState();
}

class _WallComponentLikeButtonState extends State<WallComponentLikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

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
        }
      },
      child: AnimatedBuilder(
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
    );
  }
}
