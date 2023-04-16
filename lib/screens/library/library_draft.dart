import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:writefolio/models/articles/article.dart';
import 'package:writefolio/screens/library/tools/view_type.dart';
import 'package:writefolio/screens/settings/components/avatar_picker.dart';
import 'package:writefolio/utils/tools/reading_time_approximator.dart';
import '../../data/user_article_datastore.dart';
import '../../utils/widgets/article_home_card.dart';
import '../../utils/widgets/loader.dart';
import 'components/article_view.dart';

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
    bool darkModeOn =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final savedArticleBox = articleDataStore.box;

    return ValueListenableBuilder(
        valueListenable: articleDataStore.listenToSavedArticles(),
        builder: (_, Box<UserArticle> box, Widget? child) {
          var savedArticlesList = savedArticleBox.values.toList();

          if (savedArticlesList.isEmpty) {
            return _emptyArticles(darkModeOn);
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
                            PopupMenuItem(
                              value: 'card',
                              child: Row(
                                children: const [
                                  Icon(PhosphorIcons.cards),
                                  SizedBox(width: 2),
                                  Text('Card view'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'list',
                              child: Row(
                                children: const [
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
                            ? ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const ScrollPhysics(),
                                itemCount: savedArticlesList.length,
                                itemBuilder: (_, index) {
                                  logger.i(savedArticlesList[index]);
                                  var userArticle = savedArticlesList[index];
                                  return ArticleHomeCard(
                                      userArticle: userArticle);
                                },
                              )
                            : articleCard(savedArticlesList);
                      })

                  //articleCard(savedArticlesList)
                ],
              ),
            );
          }
        });
  }

  GridView articleCard(List<UserArticle> savedArticlesList) {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: 0.8,
      padding: EdgeInsets.zero,
      mainAxisSpacing: 5,
      physics: const ScrollPhysics(),
      crossAxisCount: 2,
      children: List.generate(savedArticlesList.length, (index) {
        var userArticle = savedArticlesList[index];
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
                              imageUrl: savedArticlesList[index].imageUrl,
                              placeholder: (context, url) =>
                                  const Center(child: LoadingAnimation()),
                              errorWidget: (context, url, error) =>
                                  const Center(
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
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Text(
                        savedArticlesList[index].bodyText,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
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
                    onPressed: () {
                      // Handle bookmark icon press
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  _emptyArticles(bool darkModeOn) {
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
