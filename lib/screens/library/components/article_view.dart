import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/editor/editting.dart';
import '../../../models/articles/article.dart';
import '../../../utils/tools/reading_time_approximator.dart';
import '../../settings/components/avatar_picker.dart';

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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ContinueEditting(userArticle: widget.userArticle),
            ),
          );
        },
        label: const Text("Edit"),
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
            onPressed: () {
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                context: context,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Are you sure you want to\ndelete this article?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text("Yes"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text("No"),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(PhosphorIcons.trash),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.userArticle.title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  style: GoogleFonts.urbanist(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const AvatarComponent(radius: 17),
                    const SizedBox(width: 3),
                    const Text("Anslem"),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.bookmark_add_outlined,
                          ),
                        ),
                        PopupMenuButton<String>(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onSelected: (value) {
                            // Do something when an item is selected
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: 'share',
                              child: Text('Share'),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text(
                      "Last updated: ${widget.userArticle.updateDate}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.timer_outlined),
                    Text(
                      " ${calculateReadingTime(widget.userArticle.bodyText).toString()} min read",
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: "draftImage",
                  child: Container(
                      width: double.maxFinite,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Card(
                        child: CachedNetworkImage(
                          imageUrl: widget.userArticle.imageUrl,
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
      ),
    );
  }
}
