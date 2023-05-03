import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../models/articles/article.dart';
import '../../../utils/tools/reading_time_approximator.dart';
import '../../../utils/widgets/loader.dart';
import 'article_view.dart';

class ArchivedView extends StatefulWidget {
  const ArchivedView({super.key});

  @override
  State<ArchivedView> createState() => _ArchivedViewState();
}

class _ArchivedViewState extends State<ArchivedView> {
  final archivedComponentsBox = Hive.box<UserArticle>("archiveBox");
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: archivedComponentsBox.listenable(),
      builder: (_, settingsBoxVariable, ___) {
        List<UserArticle> archivedArticleList =
            archivedComponentsBox.values.toList();
        if (archivedArticleList.isEmpty) {
          return _emptyArticles();
        } else {
          return articleCards(archivedArticleList);
        }
      },
    );
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


  AnimatedContainer gridCardComponent(
      UserArticle userArticle, List<UserArticle> savedArticlesList, int index) {
    return AnimatedContainer(
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
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                      ),
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
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
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
    );
  }

  poemCard(BuildContext context, UserArticle userArticle) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleView(
              userArticle: userArticle,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 150.0,
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
                    height: 120,
                    width: 80,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(height: 5),
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
                    const SizedBox(height: 15.0),
                    Text(
                      "Last editted • ${userArticle.updateDate}",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                    ),
                  ],
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
              "Your archive\nis empty.",
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
