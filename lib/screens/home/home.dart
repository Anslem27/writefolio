import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/screens/home/poem_view.dart';
import 'package:writefolio/screens/home/components/poemsearch.dart';
import '../../utils/widgets/shimmer_component.dart';
import 'components/e_book.dart';
import 'components/social.dart';
import 'saved_poems.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    TabController tabcontroller = TabController(length: 4, vsync: this);
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 110,
            leading: IconButton(
              onPressed: () {
                showSearch(context: context, delegate: PoemQuerySearch());
              },
              icon: const Icon(PhosphorIcons.magnifying_glass),
            ),
            title: const Text(
              "Writefolio",
              style: TextStyle(
                fontFamily: "Chomsky",
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            pinned: true,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications),
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: tabcontroller,
                  isScrollable: true,
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
              children: const [
                Social(),
                EbookListScreen(),
                PoemView(),
                SavedPoemsScreen(),
              ],
            ),
          ),
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
        "SOCIAL WALL",
        style: GoogleFonts.ubuntu(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: Text(
        "BOOKS",
        style: GoogleFonts.ubuntu(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: Text(
        "POETRY",
        style: GoogleFonts.ubuntu(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: Text(
        "SAVED",
        style: GoogleFonts.ubuntu(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  ];
}
