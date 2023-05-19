import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      floatingActionButton: Visibility(
        visible: showFab,
        child: FloatingActionButton.extended(
          icon: const Icon(PhosphorIcons.pencil_circle),
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
          label: const Text("Save"),
        ),
      ),
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            physics: const ScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: AutoSizeTextField(
                        controller: _titleController,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: widget.userArticle.title,
                  child: Container(
                      width: double.maxFinite,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // color: Colors.orange[900]!.withOpacity(0.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: widget.userArticle.imageUrl!,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Center(
                              child: Icon(
                            Icons.image_search_outlined,
                            size: 80,
                          )),
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
              ),
              const SizedBox(height: 10),
              QuillToolbar.basic(controller: controller),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  child: QuillEditor.basic(
                    controller: controller,
                    readOnly: false, // true for view only mode
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
