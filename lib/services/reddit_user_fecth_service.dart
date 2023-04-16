import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user/reddit_user_model.dart';

Future<Data?> fetchRedditInfo(String userUrl) async {
  var url = Uri.parse('www.reddit.com/user/$userUrl/about.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return RedditModel.fromJson(json.decode(response.body)).data;
  } else {
    throw Exception('Failed to fetch reddit contents');
  }
}
