import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user/medium_user_model.dart';

/// fetch medium user object [MediumUser] with query parameter of username
Future<MediumUser> fetchUserInfo(String userName) async {
  var url = Uri.parse(
      'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@$userName');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // print(response.body);
    return MediumUser.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to fetch user info');
  }
}
