import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:writefolio/models/articles/article.dart';

class UserArticleDataStore {
  static const String boxName = "userArticles";
  final archiveBox = Hive.box<UserArticle>("archiveBox");
  final Box<UserArticle> box = Hive.box<UserArticle>(boxName);

  Future<void> saveArticle({required UserArticle userArticle}) async {
    await box.put(userArticle.id, userArticle);
  }

  /// update an exising article
  Future<void> updateArticle({required UserArticle savedArticle}) async {
    await box.put(savedArticle.id, savedArticle);
  }

  ValueListenable<Box<UserArticle>> listenToSavedArticles() {
    return Hive.box<UserArticle>(boxName).listenable(); //box.listenable();
  }

  Future<void> deleteSavedArticle({required UserArticle savedArticle}) async {
    //await archiveBox.add(savedArticle);
    await box.delete(savedArticle.id);
    // await savedArticle.delete();
  }

  Future<void> addToArchive({required UserArticle userArticle}) async {
    await archiveBox.add(userArticle);
  }

  Future<void> deleteArchived({required UserArticle userArticle}) async {
    await archiveBox.delete(userArticle.id);
  }

  Future<UserArticle?> getArticle({required String savedArticleId}) async {
    return box.get(savedArticleId);
  }
}
