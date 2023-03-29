import '../editor/create_article.dart';
import '../models/poems/poem_models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PoemService {
  static int poemCount = 20;
  //random
  static Future<HomePoemList> fetchHome() async {
    var url = Uri.parse('https://poetrydb.org/random/$poemCount');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return HomePoemList.fromJson(json.decode(response.body));
    } else {
      logger.w("Failed to fetch poems");
      throw Exception('Failed to fetch poems');
    }
  }

  //search by author
  static Future<HomePoemList> fetchSearch(String query) async {
    var url =
        Uri.parse("https://poetrydb.org/author,poemcount/$query;$poemCount");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return HomePoemList.fromJson(json.decode(response.body));
    } else {
      logger.w("Failed to fetch poems");
      throw Exception('Failed to fetch poems');
    }
  }

  //search by title {or theme}
  static Future<HomePoemList> searchByTitle(String query) async {
    var url = Uri.parse("https://poetrydb.org/title/$query");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return HomePoemList.fromJson(json.decode(response.body));
    } else {
      logger.w("Failed to fetch poems");
      throw Exception('Failed to fetch poems');
    }
  }

  //search by line from poem
  static Future<HomePoemList> searchByPoemLine(String query) async {
    var url = Uri.parse("https://poetrydb.org/lines/$query");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return HomePoemList.fromJson(json.decode(response.body));
    } else {
      logger.w("Failed to fetch poems");
      throw Exception('Failed to fetch poems by line');
    }
  }

  //query sonnets
  static Future<HomePoemList> fetchSonnets() async {
    var url = Uri.parse("https://poetrydb.org//title,random/Sonnet;$poemCount");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return HomePoemList.fromJson(json.decode(response.body));
    } else {
      logger.w("Failed to fetch Sonnets");
      throw Exception('Failed to fetch poems');
    }
  }
}
