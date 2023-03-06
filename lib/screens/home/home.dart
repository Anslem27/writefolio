import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/screens/home/poem_view.dart';
import 'package:writefolio/screens/home/poemsearch.dart';
import '../../widgets/shimmer_component.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabcontroller = TabController(length: 3, vsync: this);
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 110,
            title: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Home",
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
                onPressed: () {
                  showSearch(context: context, delegate: PoemQuerySearch());
                },
                icon: const Icon(PhosphorIcons.magnifying_glass),
              ),
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
                    insets: EdgeInsets.only(right: 6),
                  ),
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
                shimmerLoader(deviceWidth, deviceHeight),
                const PoemView(),
                //TODO: Add this to the user profile page
                shimmerLoader(deviceWidth, deviceHeight),
              ],
            ),
          )
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
        "My articles",
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: Text(
        "Poetry",
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: Text(
        "Saved",
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  ];
}
