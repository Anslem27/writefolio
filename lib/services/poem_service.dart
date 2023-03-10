import '../models/poems/poem_models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PoemService {
  static Future<HomePoemList> fetchHome() async {
    var url = Uri.parse('https://poetrydb.org/random/20');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return HomePoemList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch poems');
    }
  }

  //search by author
  static Future<HomePoemList> fetchSearch(String query) async {
    var url = Uri.parse("https://poetrydb.org/author,poemcount/$query;10");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return HomePoemList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch poems');
    }
  }
}
