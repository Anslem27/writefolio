// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:writefolio/screens/home/poem_view.dart';
import '../models/guardian_lifestyle.dart';
import '../models/rself-model.dart';

class ExplorerContents {
  Future<Rself> fetchRselfInfo() async {
    var url = Uri.parse(
        'https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.reddit.com%2Fr%2Fself.rss');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Rself.fromJson(json.decode(response.body));
    } else {
      var err = "Failed to fetch r-self url: $url info";
      logger.e(err);
      throw Exception(err);
    }
  }

  Future<GuardianLifestyle> fetchGuardianLifestyle() async {
    var url = Uri.parse(
        'https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.theguardian.com%2Flifestyle%2Frss');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return GuardianLifestyle.fromJson(json.decode(response.body));
    } else {
      var err = "Failed to fetch contents url: $url info";
      logger.e(err);
      throw Exception(err);
    }
  }
}
