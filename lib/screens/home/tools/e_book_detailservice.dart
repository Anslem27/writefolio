import 'package:flutter/material.dart';
import '../../../data/e_book_db.dart';
import '../../../models/home/e-book_category_feed.dart';
import '../../../services/e-book_service.dart';

class DetailsProvider extends ChangeNotifier {
  CategoryFeed related = CategoryFeed();
  var dlDB = DownloadsDB();
  bool loading = true;
  Entry? entry;

  EbookApi api = EbookApi();

  Future<void> getFeed(String url) async {
    try {
      CategoryFeed feed = await api.getCategory(url);
      setRelated(feed);
      setLoading(false);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setRelated(value) {
    related = value;
    notifyListeners();
  }

  Future<List> getDownload() async {
    List c = await dlDB.check({'id': entry!.id!.t.toString()});
    return c;
  }

  CategoryFeed getRelated() {
    return related;
  }

  void setEntry(value) {
    entry = value;
    notifyListeners();
  }

  // Add this method to return a future that resolves when `related` is set
  Future<CategoryFeed> waitForRelated() async {
    if (related.feed?.entry?.isNotEmpty ?? false) {
      return related;
    } else {
      await Future.delayed(const Duration(milliseconds: 100));
      return waitForRelated();
    }
  }
}
