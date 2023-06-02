import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/editor/create_article.dart' hide logger;
import 'package:writefolio/screens/navigation.dart';
import '../../models/articles/article.dart';
import 'components/archived_view.dart';
import 'components/library_draft_view.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  late TabController tabcontroller;

  @override
  void initState() {
    tabcontroller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // logger.wtf("Wtf");
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (_) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
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
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 5,
                          children: [
                            for (var articleType in articleType)
                              InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  articleType == "shortStory"
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const ArticleEditor(
                                              articleType: "ShortStory",
                                            ),
                                          ),
                                        )
                                      : articleType == "poem"
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const ArticleEditor(
                                                  articleType: "Poem",
                                                ),
                                              ),
                                            )
                                          : articleType == "quote"
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const ArticleEditor(
                                                      articleType: "Quote",
                                                    ),
                                                  ),
                                                )
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const ArticleEditor(
                                                      articleType: "Article",
                                                    ),
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
                                          articleType == "shortStory"
                                              ? "assets/illustrations/french.svg"
                                              : articleType == "poem"
                                                  ? "assets/illustrations/gimlet.svg"
                                                  : articleType == "quote"
                                                      ? "assets/illustrations/bulb.svg"
                                                      : "assets/illustrations/bag.svg",
                                          height: 60,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          articleType == "shortStory"
                                              ? "ShortStory"
                                              : articleType == "poem"
                                                  ? "Poem"
                                                  : articleType == "quote"
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
                ),
              );
            },
          );
        },
        
        child: const Icon(FluentIcons.pen_24_regular),
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
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            actions: [
              // bool to override debug parameters
              // button for bypassing auth internet stream
              if (kDebugMode)
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Navigation()));
                    },
                    icon: const Icon(Icons.home_filled))
            ],
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
              children: const [
                LibraryFiles(),
                ArchivedView(),
              ],
            ),
          )
        ],
      ),
    );
  }

  final List<Tab> _tabs = [
    Tab(
      child: Text(
        "DRAFTS",
        style: GoogleFonts.ubuntu(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: Text(
        "ARCHIVED",
        style: GoogleFonts.ubuntu(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  ];
}
