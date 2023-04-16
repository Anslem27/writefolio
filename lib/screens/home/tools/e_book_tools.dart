import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../editor/create_article.dart';
import '../../../models/home/e-book_category_feed.dart';
import '../../../services/e-book_service.dart';

class HomeProvider with ChangeNotifier {
  CategoryFeed top = CategoryFeed();
  CategoryFeed recent = CategoryFeed();

  EbookApi api = EbookApi();

  Future<void> getFeeds() async {
    try {
      CategoryFeed popular = await api.getCategory(EbookApi.popular);
      setTop(popular);
      CategoryFeed newReleases = await api.getCategory(EbookApi.recent);
      setRecent(newReleases);
    } catch (e) {
      logger.e(e.toString());
    }
  }

  void setTop(value) {
    top = value;
    notifyListeners();
  }

  CategoryFeed getTop() {
    return top;
  }

  void setRecent(value) {
    recent = value;
    notifyListeners();
  }

  CategoryFeed getRecent() {
    return recent;
  }
}
