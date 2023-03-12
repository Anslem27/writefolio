import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:writefolio/models/articles/article.dart';

class UserArticleDataStore {
  static const String boxName = "userArticles";
  final Box<UserArticle> box = Hive.box<UserArticle>(boxName);

  Future<void> saveArticle({required UserArticle userArticle}) async {
    await box.put(userArticle.id, userArticle);
  }

  Future<void> updateArticle({required UserArticle savedArticle}) async {
    await savedArticle.save();
  }

  ValueListenable<Box<UserArticle>> listenToSavedArticles() {
    return Hive.box<UserArticle>(boxName).listenable(); //box.listenable();
  }

  Future<void> deleteSavedArticle({required UserArticle savedArticle}) async {
    await savedArticle.delete();
  }

  Future<UserArticle?> getPoem({required String savedArticleId}) async {
    return box.get(savedArticleId);
  }
}
