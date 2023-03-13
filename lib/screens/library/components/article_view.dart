import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';
import '../../../models/articles/article.dart';

class ArticleView extends StatefulWidget {
  final UserArticle userArticle;
  const ArticleView({super.key, required this.userArticle});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  var date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    QuillController controller = QuillController.basic();

    var articleJsonBody = jsonDecode(widget.userArticle.body);
    controller = QuillController(
      document: Document.fromJson(articleJsonBody),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        //TODO: enable for saving and updating
        onPressed: () {},
        label: const Text("Contnue Editting"),
        icon: const Icon(Icons.edit),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.chevron_back,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(PhosphorIcons.trash),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.userArticle.title,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: GoogleFonts.urbanist(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  _userIcon(),
                  const SizedBox(width: 3),
                  const Text("Travis Aaron Wagner"),
                  const Spacer(),
                  Text(
                    widget.userArticle.updateDate,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "4 min read",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8),
              child: SizedBox(
                width: double.maxFinite,
                child: Divider(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: QuillEditor.basic(
                controller: controller,
                readOnly: true, // true for view only mode
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _userIcon() {
    return const CircleAvatar(
      radius: 17,
      backgroundImage: AssetImage("assets/avatars/Oval-3.png"),
    );
  }
}
