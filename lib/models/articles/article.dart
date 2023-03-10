import 'package:hive_flutter/adapters.dart';

@HiveType(typeId: 1)
class UserArticle extends HiveObject {
  String id;
  final String title;
  final String body;

  UserArticle({
    required this.title,
    required this.body,
    required this.id,
  });

  factory UserArticle.create(String id, String title, String body) =>
      UserArticle(title: title, body: body, id: id);
}
