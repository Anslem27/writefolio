import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:writefolio/models/articles/article.dart';
import '../../data/user_article_datastore.dart';
import '../../utils/widgets/article_home_card.dart';

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
                            label: Text(savedArticlesList.length.toString()),
                          )
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const ScrollPhysics(),
                    itemCount: savedArticlesList.length,
                    itemBuilder: (_, index) {
                      logger.i(savedArticlesList[index]);
                      var userArticle = savedArticlesList[index];
                      return ArticleHomeCard(userArticle: userArticle);
                    },
                  ),
                ],
              ),
            );
          }
        });
  }

  _emptyArticles(bool darkModeOn) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg/article.svg",
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
