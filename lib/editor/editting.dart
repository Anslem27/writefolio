import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../data/user_article_datastore.dart';
import '../models/articles/article.dart';

class ContinueEditting extends StatefulWidget {
  final UserArticle userArticle;
  const ContinueEditting({super.key, required this.userArticle});

  @override
  State<ContinueEditting> createState() => _ContinueEdittingState();
}

class _ContinueEdittingState extends State<ContinueEditting> {
  final TextEditingController _titleController = TextEditingController();
  var articleDataStore = UserArticleDataStore();
  static var currentDate = DateTime.now();
  var formattedDate = DateFormat.yMMMd().format(currentDate);

  @override
  void initState() {
    _titleController.text = widget.userArticle.title.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userArticleDataStore = UserArticleDataStore();
    var bodyJson = jsonDecode(widget.userArticle.body);
    final QuillController controller = QuillController(
      document: Document.fromJson(bodyJson),
      selection: const TextSelection.collapsed(offset: 0),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var bodyJson = jsonEncode(controller.document.toDelta().toJson());

          widget.userArticle.body = bodyJson;
          widget.userArticle.bodyText =
              controller.document.toPlainText().trim();
          widget.userArticle.title = _titleController.text.trim();
          widget.userArticle.updateDate = formattedDate;
          await userArticleDataStore
              .updateArticle(savedArticle: widget.userArticle)
              .then((value) => AnimatedSnackBar.material(
                    "${widget.userArticle.title} has been updated",
                    type: AnimatedSnackBarType.success,
                    duration: const Duration(seconds: 4),
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context));

          setState(() {});
        },
        child: const Text("Save"),
      ),
      appBar: AppBar(
        title: Text("Editting: ${_titleController.text}"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: AutoSizeTextField(
                      controller: _titleController,
                      style: GoogleFonts.lora(
                          fontWeight: FontWeight.w500, fontSize: 25),
                      decoration: const InputDecoration.collapsed(
                        //no decoration
                        hintText: "An Interesting title.",
                      ),
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            QuillToolbar.basic(controller: controller),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  child: QuillEditor.basic(
                    controller: controller,
                    readOnly: false, // true for view only mode
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
