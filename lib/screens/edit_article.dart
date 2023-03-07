import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';

class ArticleEditor extends StatefulWidget {
  const ArticleEditor({super.key});

  @override
  State<ArticleEditor> createState() => _ArticleEditorState();
}

class _ArticleEditorState extends State<ArticleEditor> {
  final QuillController _controller = QuillController.basic();
  final TextEditingController _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
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
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.chevron_back),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: TextFormField(
                          controller: _titleController,
                          style: GoogleFonts.lora(
                              fontWeight: FontWeight.w500, fontSize: 25),
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(width: 2),
                            ),
                            labelText: 'Article title',
                            labelStyle: GoogleFonts.lora(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
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
