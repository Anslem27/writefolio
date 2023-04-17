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

  @HiveField(5)
  String? imageUrl;

  // @HiveField(6)
  // ArticleType? articleType;

  UserArticle({
    required this.title,
    required this.body,
    required this.bodyText,
    required this.id,
    required this.updateDate,
    required this.imageUrl,
    // required this.articleType,
  });

  factory UserArticle.create({
    id,
    required String title,
    required String body,
    required String bodyText,
    required String updateDate,
    required String? imageUrl,
    // ArticleType? articleType,
  }) =>
      UserArticle(
        id: const Uuid().v1(), //unique id
        title: title,
        body: body,
        bodyText: bodyText,
        updateDate: updateDate,
        imageUrl: imageUrl,
        // articleType: articleType,
      );
}

enum ArticleType {
  article,
  poem,
  shortStory,
  quote,
}
