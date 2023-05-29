// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
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
import '../screens/navigation.dart';
import '../utils/widgets/loader.dart';

var logger = Logger();

class ArticleEditor extends StatefulWidget {
  final String articleType;
  const ArticleEditor({super.key, required this.articleType});

  @override
  State<ArticleEditor> createState() => _ArticleEditorState();
}

class _ArticleEditorState extends State<ArticleEditor> {
  final QuillController _controller = QuillController.basic();

  final TextEditingController _titleController = TextEditingController();
  var articleDataStore = UserArticleDataStore();
  static var currentDate = DateTime.now();
  var formattedDate = DateFormat.yMMMd().format(currentDate);
  var defaultImage =
      "https://fastly.picsum.photos/id/20/3670/2462.jpg?hmac=CmQ0ln-k5ZqkdtLvVO23LjVAEabZQx2wOaT4pyeG10I";

  String? selectedImageUrl = "";
  late List<ImageModel> images;
  bool isExpanded = false;

  Future<List<ImageModel>> fetchImages() async {
    final response = await http
        .get(Uri.parse('https://picsum.photos/v2/list?page=2&limit=100'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        images = responseData.map((json) => ImageModel.fromJson(json)).toList();
      });

      return images;
    } else {
      logger.w("Failed to load images");
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    /// hide FAB when keyboard is on
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    /* _controller.addListener(() {
      if (_controller.document.toPlainText().isEmpty) {
        // Document is empty, so insert default text
        _controller.document = Document()
          ..insert(0,
              'You can start typing here and use all the formatting options available.');
      } else {
        // Document is not empty, so clear it
        _controller.document.delete(0, _controller.document.length);
      }
    }); */
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                context: context,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Are you sure you want to\nquit creating?",
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
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil<void>(
                                        context,
                                        MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                const Navigation()),
                                        ModalRoute.withName('/navigation'),
                                      ).then((value) =>
                                          AnimatedSnackBar.material(
                                            "You've quit creating",
                                            type: AnimatedSnackBarType.info,
                                            duration:
                                                const Duration(seconds: 4),
                                            mobileSnackBarPosition:
                                                MobileSnackBarPosition.bottom,
                                          ).show(context));
                                    },
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
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(CupertinoIcons.chevron_back),
        ),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).secondaryHeaderColor,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              widget.articleType,
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _titleController.clear();
              setState(() {});
            },
            icon: const Icon(Icons.clear),
          ),
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder(
                            future: fetchImages(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                // images = snapshot.data;
                                return SizedBox(
                                  height: 400,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          'Pick cover Image',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GridView.count(
                                          crossAxisCount: 3,
                                          children: List.generate(
                                            images.length,
                                            (index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    logger.i(
                                                        "Added ${images[index].downloadUrl} as image url");
                                                    setState(() {
                                                      selectedImageUrl =
                                                          images[index]
                                                              .downloadUrl;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: images[index]
                                                          .downloadUrl,
                                                      progressIndicatorBuilder:
                                                          (_, string,
                                                              progress) {
                                                        return const Center(
                                                          child:
                                                              LoadingAnimation(),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/illustrations/no-connection.svg",
                                      height: 150,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${snapshot.error}\nYou need Internet for this feature',
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: LoadingAnimation(),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.image))
        ],
      ),
      floatingActionButton: Visibility(
        visible: showFab,
        child: FloatingActionButton.extended(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _controller.document.toPlainText().isNotEmpty) {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                context: context,
                builder: (_) => SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "You are creating\n'${_titleController.text.trim()}'",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                    child: OutlinedButton.icon(
                                      icon: const Icon(PhosphorIcons.quotes),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                          bodyText: _controller.document
                                              .toPlainText(),
                                          updateDate: formattedDate,
                                          type: widget.articleType,
                                          imageUrl: selectedImageUrl == ""
                                              ? defaultImage
                                              : selectedImageUrl,
                                        );

                                        logger.i(
                                          "${userArticle.body}\n${userArticle.updateDate}\n${userArticle.id}\n${userArticle.bodyText}\n${userArticle.imageUrl}",
                                        );
                                        logger.wtf(userArticle.type);
                                        //create article object
                                        await articleDataStore
                                            .saveArticle(
                                                userArticle: userArticle)
                                            .then((value) {
                                          AnimatedSnackBar.material(
                                            "${userArticle.title} has been saved",
                                            type: AnimatedSnackBarType.success,
                                            duration:
                                                const Duration(seconds: 4),
                                            mobileSnackBarPosition:
                                                MobileSnackBarPosition.bottom,
                                          ).show(context).then((value) {
                                            Navigator.pop(context);
                                          });
                                        });

                                        // ignore: use_build_context_synchronously
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            "/navigation",
                                            (route) => false);
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
                      ),
                    ),
                  ),
                ),
              );
            }
            if (_titleController.text.isEmpty &&
                _controller.document.toPlainText().isEmpty) {
              AnimatedSnackBar.material(
                'Title or body can not be empty.',
                type: AnimatedSnackBarType.warning,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
            }
          },
          icon: const Icon(
            PhosphorIcons.pen_nib,
            size: 30,
          ),
          label: const Text("Create and save"),
        ),
      ),
      body: SafeArea(
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
                      style: GoogleFonts.urbanist(
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
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: double.maxFinite,
                  height: isExpanded ? 150 : 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: selectedImageUrl == ""
                          ? defaultImage
                          : selectedImageUrl!,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Center(
                          child: Icon(
                        PhosphorIcons.image,
                        size: 70,
                      )),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            QuillToolbar.basic(
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
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                child: QuillEditor.basic(
                  controller: _controller,
                  readOnly: false, // true for view only mode
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ImageModel {
  final String id;
  final String author;
  final String downloadUrl;

  ImageModel({
    required this.id,
    required this.author,
    required this.downloadUrl,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      author: json['author'],
      downloadUrl: json['download_url'],
    );
  }
}
