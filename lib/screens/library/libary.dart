import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/editor/create_article.dart' hide logger;
import '../../models/articles/article.dart';
import '../../utils/widgets/shimmer_component.dart';
import 'library_draft.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabcontroller = TabController(length: 2, vsync: this);
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // logger.wtf("Wtf");
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            context: context,
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "What do you want to create?",
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 5,
                        children: [
                          for (var articleType in ArticleType.values)
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                /* articleType == ArticleType.shortStory
                                            ? "assets/illustrations/french.svg"
                                            : articleType == ArticleType.poem
                                                ? "assets/illustrations/gimlet.svg"
                                                : articleType ==
                                                        ArticleType.quote
                                                    ? "assets/illustrations/bulb.svg"
                                                    : "assets/illustrations/bag.svg", */
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ArticleEditor(),
                                  ),
                                );
                              },
                              child: Card(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 90,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: SvgPicture.asset(
                                        articleType == ArticleType.shortStory
                                            ? "assets/illustrations/french.svg"
                                            : articleType == ArticleType.poem
                                                ? "assets/illustrations/gimlet.svg"
                                                : articleType ==
                                                        ArticleType.quote
                                                    ? "assets/illustrations/bulb.svg"
                                                    : "assets/illustrations/bag.svg",
                                        height: 60,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        articleType == ArticleType.shortStory
                                            ? "ShortStory"
                                            : articleType == ArticleType.poem
                                                ? "Poem"
                                                : articleType ==
                                                        ArticleType.quote
                                                    ? "Quote"
                                                    : "Article",
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        label: const Text("Create"),
        icon: const Icon(PhosphorIcons.pencil),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 110,
            title: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "Your Library",
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            pinned: true,
            centerTitle: false,
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
              children: [
                const LibraryFiles(),
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
        "Drafts",
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: Text(
        "Archived",
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  ];
}
