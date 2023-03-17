import 'package:html/parser.dart' show parseFragment;

String? htmlToPlainText(String htmlString) {
  final document = parseFragment(htmlString);
  return document.text;
}
