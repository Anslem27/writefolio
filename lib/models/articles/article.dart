import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';

part 'article.g.dart';

@HiveType(typeId: 1)
class UserArticle extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  String bodyText;

  @HiveField(4)
  String updateDate;

  UserArticle({
    required this.title,
    required this.body,
    required this.bodyText,
    required this.id,
    required this.updateDate,
  });

  factory UserArticle.create(String id, String title, String body,
          String bodyText, String updateDate) =>
      UserArticle(
        id: const Uuid().v1(), //unique id
        title: title,
        body: body,
        bodyText: bodyText,
        updateDate: updateDate,
      );
}
