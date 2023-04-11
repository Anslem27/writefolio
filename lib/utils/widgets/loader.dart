import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.stretchedDots(size: 35, color: Colors.pink);
  }
}
