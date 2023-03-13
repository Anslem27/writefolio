import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:writefolio/models/articles/article.dart';

import '../data/user_article_datastore.dart';

var logger = Logger();

class ArticleEditor extends StatefulWidget {
  const ArticleEditor({super.key});

  @override
  State<ArticleEditor> createState() => _ArticleEditorState();
}

class _ArticleEditorState extends State<ArticleEditor> {
  final QuillController _controller = QuillController.basic();
  final TextEditingController _titleController = TextEditingController();
  var articleDataStore = UserArticleDataStore();
  static var currentDate = DateTime.now();
  var formattedDate = DateFormat.yMMMd().format(currentDate);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              //TODO: Add an are you sure dialog box.
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.chevron_back),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (_) => Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3),
                            topRight: Radius.circular(3)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "You are creating\n",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: '"${_titleController.text.trim()}"',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Keep Editting",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.save_as_outlined),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () async {
                                      var bodyJson = jsonEncode(_controller
                                          .document
                                          .toDelta()
                                          .toJson());

                                      // create article object
                                      var userArticle = UserArticle.create(
                                        title: _titleController.text.trim(),
                                        body: bodyJson,
                                        bodyText:
                                            _controller.document.toPlainText(),
                                        updateDate: formattedDate,
                                      );

                                      logger.i(
                                        "${userArticle.body}\n${userArticle.updateDate}\n${userArticle.id}\n${userArticle.bodyText}",
                                      );
                                      //create article object
                                      await articleDataStore
                                          .saveArticle(userArticle: userArticle)
                                          .then((value) =>
                                              AnimatedSnackBar.material(
                                                "${userArticle.title} has been saved",
                                                type: AnimatedSnackBarType
                                                    .success,
                                                duration:
                                                    const Duration(seconds: 4),
                                                mobileSnackBarPosition:
                                                    MobileSnackBarPosition
                                                        .bottom,
                                              ).show(context));

                                      // ignore: use_build_context_synchronously
                                      Navigator.popAndPushNamed(
                                          context, "/library");
                                    },
                                    label: const Text(
                                      "Save Article",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ));
          },
          child: const Icon(
            Icons.save_as_rounded,
            size: 30,
          ),
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
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.all(10),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(width: 20),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelText: 'Article title',
                          labelStyle: GoogleFonts.lora(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
              ),
              QuillToolbar.basic(controller: _controller),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    child: QuillEditor.basic(
                      controller: _controller,
                      readOnly: false, // true for view only mode
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
