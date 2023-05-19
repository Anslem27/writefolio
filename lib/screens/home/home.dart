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
            title: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "Writefolio",
                style: GoogleFonts.roboto(
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
        "Social wall",
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: Text(
        "Read",
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: Text(
        "Poetry",
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: Text(
        "Saved",
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  ];
}
