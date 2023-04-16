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
            activeIcon: Icon(PhosphorIcons.house_fill),
            icon: Icon(PhosphorIcons.house),
            tooltip: "Home",
            label: "Home",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(PhosphorIcons.bookmarks_simple_fill),
            icon: Icon(PhosphorIcons.bookmarks_simple),
            tooltip: "Your library",
            label: "Your library",
          ),
          BottomNavigationBarItem(
            activeIcon: AvatarComponent(radius: 17),
            icon: AvatarComponent(radius: 17),
            tooltip: "Writefolio profile",
            label: "Writefolio Profile",
          ),
        ],
      ),
    );
  }
}
