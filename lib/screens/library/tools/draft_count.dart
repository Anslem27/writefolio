import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../data/user_article_datastore.dart';
import '../../../models/poems/saved_poems.dart';

/// Saved Articles count
class DraftCount extends StatelessWidget {
  const DraftCount({super.key});

  @override
  Widget build(BuildContext context) {
    var articleDataStore = UserArticleDataStore();
    final savedArticleBox = articleDataStore.box;
    return ValueListenableBuilder(
        valueListenable: savedArticleBox.listenable(),
        builder: (_, __, ____) {
          var savedArticlesList = savedArticleBox.values.toList();
          return Text(
            "${savedArticlesList.length.toString()} ${savedArticlesList.length > 1 ? "drafts" : "draft"}",
            style: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          );
        });
  }
}

/// Saved poem [SavedPoems] count
class SavedPoemCount extends StatelessWidget {
  const SavedPoemCount({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box<SavedPoems>("savedPoems").listenable(),
        builder: (_, savedPoemBox, ____) {
          var savedPoems = savedPoemBox.values.toList();
          return Text(
            "${savedPoems.length.toString()} saved ${savedPoems.length > 1 ? "poems" : "poem"}",
            style: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          );
        });
  }
}
