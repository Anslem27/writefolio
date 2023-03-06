import '../models/poem_models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PoemService {
  static Future<HomePoemList> fetchHome() async {
    var url = Uri.parse('https://poetrydb.org/random/20');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // print(response.body);
      return HomePoemList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch poems');
    }
  }
}
