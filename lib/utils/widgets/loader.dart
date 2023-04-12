// ignore_for_file: implementation_imports, unused_import
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import "package:flutter/src/material/theme.dart" hide Theme;
import 'package:flutter/material.dart' hide Theme;
import '../theme/theme_model.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Theme>("themes").listenable(),
        builder: (_, __, ___) {
          final theme = themeBox.get('selected_theme',
              defaultValue: Theme("default", const Color(0xfffbd38d).value));
          return LoadingAnimationWidget.stretchedDots(
            size: 35,
            color: Color(theme!.colorValue),
          );
        });
  }
}
