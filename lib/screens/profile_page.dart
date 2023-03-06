import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/shimmer_component.dart';
import '../widgets/theme_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabcontroller = TabController(length: 1, vsync: this);
    bool darkModeOn =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 110,
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Your Profile",
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            pinned: true,
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  EvaIcons.settings2Outline,
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: tabcontroller,
                  isScrollable: true,
                  indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(width: 2),
                      insets: EdgeInsets.only(right: 6)),
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return states.contains(MaterialState.focused)
                          ? null
                          : Colors.transparent;
                    },
                  ),
                  tabs: _tabs,
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: tabcontroller,
              children: [
                _centeredPage(darkModeOn),
              ],
            ),
          )
        ],
      ),
    );
  }

  _centeredPage(bool isDarkModeOn) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //TODO: Add darkmode illustration
          SvgPicture.asset(!isDarkModeOn ? "assets/svg/meditating.svg" : ""),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Profile under\nconstruction...",
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ),
          const SButton(text: "See more")
        ],
      ),
    );
  }

  ListView shimmerLoader(double deviceWidth, double deviceHeight) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, index) {
        return ShimmerComponent(
          deviceWidth: deviceWidth,
          deviceHeight: deviceHeight,
        );
      },
    );
  }

  final List<Tab> _tabs = [
    Tab(
      child: Text(
        "About",
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  ];
}
