import 'package:hive_flutter/adapters.dart';
import 'package:writefolio/models/articles/article.dart';

class UserArticleDataStore {
  static const String boxName = "userArticles";
  final Box<UserArticle> box = Hive.box<UserArticle>(boxName);

  Future<void> saveArticle({required UserArticle userArticle}) async {
    await box.put(userArticle.id, userArticle);
  }
}
