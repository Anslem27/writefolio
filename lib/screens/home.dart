import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabcontroller = TabController(length: 2, vsync: this);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            automaticallyImplyLeading: false,
            title: Text(
              "Home",
              style: GoogleFonts.urbanist(color: Colors.black, fontSize: 25),
            ),
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
                    tabs: [
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
                          "Favourites",
                          style: GoogleFonts.urbanist(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: tabcontroller,
              children: const [
                Center(
                  child: Text("1"),
                ),
                Center(
                  child: Text("2"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
