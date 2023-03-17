// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/guardian_lifestyle.dart';
import '../models/rself-model.dart';

Future<Rself> fetchRselfInfo(String userName) async {
  var url = Uri.parse(
      'https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.reddit.com%2Fr%2Fself.rss');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // print(response.body);
    return Rself.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to fetch r-self info');
  }
}

Future<GuardianLifestyle> fetchGuardianLifestyle(String userName) async {
  var url = Uri.parse('https://www.theguardian.com/lifestyle/rss');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // print(response.body);
    return GuardianLifestyle.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to fetch guardian $url info');
  }
}
