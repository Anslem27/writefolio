import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:writefolio/screens/home/home.dart';
import 'package:writefolio/screens/profile_page.dart';
import 'package:writefolio/screens/settings/components/avatar_picker.dart';
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
    ProfileScreen(),
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
            activeIcon: Icon(PhosphorIcons.bookmark_fill),
            icon: Icon(PhosphorIcons.bookmark),
            tooltip: "Library",
            label: "Library",
          ),
          BottomNavigationBarItem(
            activeIcon: AvatarComponent(radius: 17),
            icon: AvatarComponent(radius: 17),
            tooltip: "Settings",
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
