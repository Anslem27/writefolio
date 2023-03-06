import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:writefolio/screens/home.dart';

import 'edit_article.dart';
import 'library/libary.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final appBody = const [
    HomeScreen(),
    LibraryScreen(),
    ArticleEditor(),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appBody[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 28,
        currentIndex: currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(EvaIcons.home),
            icon: Icon(EvaIcons.homeOutline),
            tooltip: "Home",
            label: "Home",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(EvaIcons.bookmark),
            icon: Icon(EvaIcons.bookmarkOutline),
            tooltip: "Library",
            label: "Library",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(EvaIcons.settings2),
            icon: Icon(EvaIcons.settings2Outline),
            tooltip: "Settings",
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
