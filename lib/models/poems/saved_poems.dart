import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'saved_poems.g.dart';

@HiveType(typeId: 0)
class SavedPoems extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final List<String> lines;

  @HiveField(3)
  final String linecount;

  @HiveField(4)
  bool? isSaved;

  @HiveField(5)
  String id;

  SavedPoems(
      {required this.id,
      required this.title,
      required this.author,
      required this.lines,
      required this.linecount,
      required isSaved});

  factory SavedPoems.create({
    required String title,
    id,
    required String author,
    required List<String> lines,
    required String linecount,
    required bool isSaved,
  }) =>
      SavedPoems(
        id: const Uuid().v1(), //unique id
        title: title,
        author: author,
        lines: lines,
        linecount: linecount,
        isSaved: false,
      );
}
