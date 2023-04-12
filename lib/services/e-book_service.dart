// ignore_for_file: file_names

import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:writefolio/editor/create_article.dart';
import 'package:xml2json/xml2json.dart';

import '../models/home/e-book_category_feed.dart';

class EbookApi {
  static String baseURL = 'https://catalog.feedbooks.com';
  static String publicDomainURL = '$baseURL/publicdomain/browse';
  static String popular = '$publicDomainURL/top.atom';
  static String recent = '$publicDomainURL/recent.atom';
  static String awards = '$publicDomainURL/awards.atom';
  static String noteworthy = '$publicDomainURL/homepage_selection.atom';
  static String shortStory = '$publicDomainURL/top.atom?cat=FBFIC029000';
  static String sciFi = '$publicDomainURL/top.atom?cat=FBFIC028000';
  static String actionAdventure = '$publicDomainURL/top.atom?cat=FBFIC002000';
  static String mystery = '$publicDomainURL/top.atom?cat=FBFIC022000';
  static String romance = '$publicDomainURL/top.atom?cat=FBFIC027000';
  static String horror = '$publicDomainURL/top.atom?cat=FBFIC015000';

  Future<CategoryFeed> getCategory(String url) async {
    var res = await http.get(Uri.parse(url)).catchError((e) {
      throw (e);
    });
    CategoryFeed category;
    if (res.statusCode == 200) {
      Xml2Json xml2json = Xml2Json();
      xml2json.parse(res.body.toString());
      var json = jsonDecode(xml2json.toGData());
      category = CategoryFeed.fromJson(json);
    } else {
      logger.e('Error ${res.statusCode}');
      throw ('Error ${res.statusCode}');
    }
    return category;
  }
}
