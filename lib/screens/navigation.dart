import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:writefolio/screens/home/home.dart';
import 'package:writefolio/screens/profile/profile_page.dart';
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
    return ValueListenableBuilder(
      valueListenable: Hive.box("settingsBox").listenable(),
      builder: (_, settingsBox, ___) {
        bool hideNavBarLabels = Hive.box("settingsBox")
            .get('hideNavbarLabels', defaultValue: false);
        return Scaffold(
          body: appBody[currentIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            labelBehavior: !hideNavBarLabels
                ? NavigationDestinationLabelBehavior.alwaysShow
                : NavigationDestinationLabelBehavior.alwaysHide,
            onDestinationSelected: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(FluentIcons.home_28_filled),
                icon: Icon(FluentIcons.home_28_regular),
                tooltip: "Home",
                label: "Home",
              ),
              NavigationDestination(
                selectedIcon: Icon(PhosphorIcons.bookmarks_simple_fill),
                icon: Icon(PhosphorIcons.bookmarks_simple),
                tooltip: "Your library",
                label: "Your library",
              ),
              NavigationDestination(
                selectedIcon: AvatarComponent(radius: 15),
                icon: AvatarComponent(radius: 15),
                tooltip: "Profile",
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }
}
