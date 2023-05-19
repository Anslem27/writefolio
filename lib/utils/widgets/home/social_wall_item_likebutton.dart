import 'package:flutter/material.dart';

class WallComponentLikeButton extends StatefulWidget {
  final Function()? ontap;
  final bool isLiked;

  const WallComponentLikeButton({
    super.key,
    this.ontap,
    required this.isLiked,
  });

  @override
  State<WallComponentLikeButton> createState() =>
      _WallComponentLikeButtonState();
}

class _WallComponentLikeButtonState extends State<WallComponentLikeButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: widget.isLiked
          ? Icon(
              Icons.favorite,
              color: Colors.red[800],
            )
          : const Icon(Icons.favorite_outline),
    );
  }
}
