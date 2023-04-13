// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class HorizontalScrollWidget extends StatefulWidget {
  const HorizontalScrollWidget({super.key});

  @override
  _HorizontalScrollWidgetState createState() => _HorizontalScrollWidgetState();
}

class _HorizontalScrollWidgetState extends State<HorizontalScrollWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          setState(() {
            _isExpanded = true;
          });
        } else if (details.primaryVelocity! < 0) {
          setState(() {
            _isExpanded = false;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: _isExpanded ? MediaQuery.of(context).size.width : 200,
        height: 200,
        color: Colors.blue,
        child: const Center(
          child: Text(
            'Horizontal Scroll Widget',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
