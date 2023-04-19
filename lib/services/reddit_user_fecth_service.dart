import 'dart:convert';
import 'package:http/http.dart' as http;
import '../editor/create_article.dart';
import '../models/user/reddit_user_model.dart';

Future<Data?>? fetchRedditInfo(String userUrl) async {
  var url = Uri.https('www.reddit.com', 'user/$userUrl/about.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    logger.i("Got reddit stuff");
    return RedditModel.fromJson(json.decode(response.body)).data;
  } else {
    logger.e("Error fetching reddit contents");
    throw Exception('Failed to fetch repos');
  }
}
