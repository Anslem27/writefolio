// import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/screens/library/components/library_draft_view.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class WritingEditor extends StatefulWidget {
  const WritingEditor({super.key});

  @override
  State<WritingEditor> createState() => _WritingEditorState();
}

class _WritingEditorState extends State<WritingEditor> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final titleController = TextEditingController();
  final tagsController = TextEditingController();
  List<String> tags = [];
  ScrollController scrollController = ScrollController();
  final _controller = quill.QuillController.basic();

  bool showHintText = true;

  void postWriting() async {
    try {
      final doc = _controller.getPlainText();
      //TODO: get quill json
      if (doc.isNotEmpty && tags.isNotEmpty) {
        FirebaseFirestore.instance.collection("User Posts").add({
          "UserEmail": currentUser.email,
          "Title": titleController.text.trim(),
          "Writing": doc,
          "Tags": tags,
          "TimeStamp": Timestamp.now(),
          "Likes": [],
        });
        Navigator.pop(context);
      }
    } catch (e) {
      logger.i(e.toString());
    }
  }

  void addTag() {
    final newTag = tagsController.text.trim();
    if (newTag.isNotEmpty && !tags.contains(newTag)) {
      setState(() {
        tags.add(newTag);
        tagsController.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        showHintText = _controller.document.isEmpty();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: OutlinedButton(
              onPressed: () {
                postWriting();
              },
              child: const Text("Done"),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: titleController,
              style: GoogleFonts.urbanist(fontSize: 22),
              decoration: const InputDecoration.collapsed(
                hintText: "Enter heading",
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  quill.QuillEditor(
                    controller: _controller,
                    scrollController: scrollController,
                    scrollable: true,
                    autoFocus: false,
                    focusNode: FocusNode(),
                    readOnly: false,
                    expands: true,
                    padding: EdgeInsets.zero,
                  ),
                  if (showHintText)
                    Positioned(
                      top: 12.0,
                      left: 2.0,
                      child: Text(
                        'Write your content here.',
                        style: GoogleFonts.urbanist(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 8.0,
              runSpacing: 4.0,
              children: tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: tagsController,
                      style: const TextStyle(fontFamily: 'Urbanist'),
                      decoration: const InputDecoration.collapsed(
                          hintText: "Add tags")),
                ),
                IconButton(
                  onPressed: addTag,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: quillToolBar(),
    );
  }

  quill.QuillToolbar quillToolBar() {
    return quill.QuillToolbar.basic(
      controller: _controller,
      showLink: false,
      showBackgroundColorButton: false,
      showCodeBlock: false,
      showColorButton: false,
      showDirection: false,
      showInlineCode: false,
      showListBullets: false,
      showUnderLineButton: false,
      showListNumbers: false,
      showLeftAlignment: false,
      showSearchButton: false,
      showClearFormat: false,
      showListCheck: false,
      showStrikeThrough: false,
    );
  }
}
