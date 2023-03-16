// ignore_for_file: file_names

/* import 'dart:convert';
import 'package:http/http.dart' as http;

Future<MediumUser> fetchUserInfo(String userName) async {
  var url = Uri.parse(
      'https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.reddit.com%2Fr%2Fself.rss');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // print(response.body);
    return MediumUser.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to fetch r-self info');
  }
}
 */