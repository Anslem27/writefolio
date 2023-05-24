import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:writefolio/models/articles/article.dart';
import 'package:writefolio/screens/library/tools/view_type.dart';
import 'package:writefolio/utils/tools/reading_time_approximator.dart';
import '../../../data/user_article_datastore.dart';
import '../../../utils/tools/timeStamp_helper.dart';
import '../../../utils/widgets/article_home_card.dart';
import '../../../utils/widgets/loader.dart';
import 'article_view.dart';

var logger = Logger();

class LibraryFiles extends StatefulWidget {
  const LibraryFiles({super.key});

  @override
  State<LibraryFiles> createState() => _LibraryFilesState();
}

class _LibraryFilesState extends State<LibraryFiles> {
  var articleDataStore = UserArticleDataStore();

  @override
  Widget build(BuildContext context) {
    final savedArticleBox = articleDataStore.box;

    return ValueListenableBuilder(
        valueListenable: articleDataStore.listenToSavedArticles(),
        builder: (_, Box<UserArticle> box, Widget? child) {
          var savedArticlesList = savedArticleBox.values.toList();

          if (savedArticlesList.isEmpty) {
            return _emptyArticles();
          } else {
            return SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Draft"),
                                const SizedBox(width: 5),
                                Badge(
                                  label:
                                      Text(savedArticlesList.length.toString()),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onSelected: (value) {
                            // Store the user's selected layout type in the Layout box
                            switch (value) {
                              case 'card':
                                Hive.box<LayoutType>('Layout')
                                    .put('type', LayoutType.card);

                                logger.d("Layout type changed to card");
                                break;
                              case 'list':
                                Hive.box<LayoutType>('Layout')
                                    .put('type', LayoutType.list);

                                logger.d("Layout type changed to list");
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: 'card',
                              child: Row(
                                children: [
                                  Icon(PhosphorIcons.cards),
                                  SizedBox(width: 2),
                                  Text('Card view'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'list',
                              child: Row(
                                children: [
                                  Icon(Icons.list_rounded),
                                  SizedBox(width: 2),
                                  Text('List view'),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                      valueListenable:
                          Hive.box<LayoutType>("Layout").listenable(),
                      builder: (_, viewBox, ___) {
                        var boxValue =
                            viewBox.get('type', defaultValue: LayoutType.list);
                        return boxValue == LayoutType.list
                            ? listViewComponents(savedArticlesList)
                            : articleCards(savedArticlesList);
                      })

                  //articleCard(savedArticlesList)
                ],
              ),
            );
          }
        });
  }

  listViewComponents(List<UserArticle> savedArticlesList) {
    List<UserArticle> poems = [];
    List<UserArticle> nonPoems = [];

    // separate the poems and non-poems into separate lists
    for (var article in savedArticlesList) {
      if (article.type == 'Poem') {
        poems.add(article);
      } else {
        nonPoems.add(article);
      }
    }
    // render the appropriate widget based on the article type
    if (poems.isNotEmpty && nonPoems.isNotEmpty) {
      return ListView(
        physics: const ScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Poems',
              style: GoogleFonts.roboto(fontSize: 20),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            itemCount: poems.length,
            itemBuilder: (context, index) {
              var userArticle = poems[index];
              return poemCard(context, userArticle);
            },
          ),
          // Text('Non-Poems'),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            itemCount: nonPoems.length,
            itemBuilder: (_, index) {
              logger.i(nonPoems[index]);
              var userArticle = nonPoems[index];
              return ArticleHomeCard(userArticle: userArticle);
            },
          )
        ],
      );
    } else if (poems.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        itemCount: poems.length,
        itemBuilder: (context, index) {
          var userArticle = poems[index];
          return poemCard(context, userArticle);
        },
      );
    } else if (nonPoems.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        itemCount: nonPoems.length,
        itemBuilder: (_, index) {
          logger.i(nonPoems[index]);
          var userArticle = nonPoems[index];
          return ArticleHomeCard(userArticle: userArticle);
        },
      );
    } else {
      return const SizedBox();
    }
  }

  articleCards(List<UserArticle> savedArticlesList) {
    List<UserArticle> poems = [];
    List<UserArticle> nonPoems = [];

    // separate the poems and non-poems into separate lists
    for (var article in savedArticlesList) {
      if (article.type == 'Poem') {
        poems.add(article);
      } else {
        nonPoems.add(article);
      }
    }

    // render the appropriate widget based on the article type
    if (poems.isNotEmpty && nonPoems.isNotEmpty) {
      return ListView(
        physics: const ScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Poems',
              style: GoogleFonts.roboto(fontSize: 18),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            itemCount: poems.length,
            itemBuilder: (context, index) {
              var userArticle = poems[index];
              return poemCard(context, userArticle);
            },
          ),
          // Text('Non-Poems'),
          StaggeredGridView.countBuilder(
            shrinkWrap: true,
            crossAxisCount: 2,
            padding: EdgeInsets.zero,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            physics: const ScrollPhysics(),
            itemCount: nonPoems.length,
            itemBuilder: (context, index) {
              var userArticle = nonPoems[index];
              return gridCardComponent(userArticle, nonPoems, index);
            },
            staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
          ),
        ],
      );
    } else if (poems.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        itemCount: poems.length,
        itemBuilder: (context, index) {
          var userArticle = poems[index];
          return poemCard(context, userArticle);
        },
      );
    } else if (nonPoems.isNotEmpty) {
      return StaggeredGridView.countBuilder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        physics: const ScrollPhysics(),
        itemCount: nonPoems.length,
        itemBuilder: (context, index) {
          var userArticle = nonPoems[index];
          return gridCardComponent(userArticle, nonPoems, index);
        },
        staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
      );
    } else {
      return const SizedBox();
    }
  }

  poemCard(BuildContext context, UserArticle userArticle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArticleView(
                isArchived: false,
                userArticle: userArticle,
              ),
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              elevation: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: SvgPicture.asset(
                  "assets/illustrations/gimlet.svg",
                  height: 100,
                  width: 80,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Material(
                    type: MaterialType.transparency,
                    child: Text(
                      userArticle.title,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).textTheme.titleMedium!.color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "Last editted • ${formatTimeDifference(userArticle.updateDate)}",
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: Text(
                      userArticle.bodyText,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  gridCardComponent(
      UserArticle userArticle, List<UserArticle> savedArticlesList, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleView(
                        isArchived: false,
                        userArticle: userArticle,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Hero(
                      tag: userArticle.title,
                      child: Container(
                        height: 100,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: savedArticlesList[index].imageUrl!,
                            placeholder: (context, url) =>
                                const Center(child: LoadingAnimation()),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(
                                Icons.image_search_outlined,
                                size: 80,
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        savedArticlesList[index].title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: GoogleFonts.roboto(fontSize: 15),
                      ),
                    ),
                    Text(
                      savedArticlesList[index].bodyText,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "${calculateReadingTime(savedArticlesList[index].bodyText.trim()).toString()} min read  •  ${savedArticlesList[index].bodyText.trim().split(" ").length.toString()} words",
                            style: const TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.bookmark_border,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _emptyArticles() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/illustrations/no-fav.svg",
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Your draft\nis empty.",
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
