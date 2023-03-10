class HomePoemList {
  List<PoemModel>? poem;
  HomePoemList({this.poem});

  factory HomePoemList.fromJson(List<dynamic> json) {
    List<PoemModel> poems = <PoemModel>[];
    poems = json.map((e) => PoemModel.fromJson(e)).toList();
    return HomePoemList(poem: poems);
  }
}

class PoemModel {
  late final String title;
  late final String author;
  late final List<String> lines;
  late final String linecount;

  PoemModel(
      {required this.title,
      required this.author,
      required this.lines,
      required this.linecount});

  PoemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    author = json['author'];
    lines = json['lines'].cast<String>();
    linecount = json['linecount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['author'] = author;
    data['lines'] = lines;
    data['linecount'] = linecount;
    return data;
  }
}
