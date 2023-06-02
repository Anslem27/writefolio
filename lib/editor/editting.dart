import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../data/user_article_datastore.dart';
import '../models/articles/article.dart';
import 'package:http/http.dart' as http;

import '../utils/widgets/loader.dart';
import 'create_article.dart';

class ContinueEditting extends StatefulWidget {
  final UserArticle userArticle;
  const ContinueEditting({super.key, required this.userArticle});

  @override
  State<ContinueEditting> createState() => _ContinueEdittingState();
}

class _ContinueEdittingState extends State<ContinueEditting>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _titleController = TextEditingController();
  var articleDataStore = UserArticleDataStore();
  static var currentDate = DateTime.now();
  var formattedDate = DateFormat.yMMMd().format(currentDate);
  bool showWidget = true;

  String? selectedImageUrl = "";
  late List<ImageModel> images;
  @override
  void initState() {
    _titleController.text = widget.userArticle.title.toString();
    selectedImageUrl = widget.userArticle.imageUrl;
    super.initState();
  }

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
    super.build(context);
    var userArticleDataStore = UserArticleDataStore();
    var bodyJson = jsonDecode(widget.userArticle.body);
    final QuillController controller = QuillController(
      document: Document.fromJson(bodyJson),
      selection: const TextSelection.collapsed(offset: 0),
    );
    // final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              AnimatedSnackBar.material(
                "Tap on image to hide it",
                type: AnimatedSnackBarType.info,
                duration: const Duration(seconds: 4),
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
            },
            icon: const Icon(Icons.info_outline),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_rounded),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                        (_, string, progress) {
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
            icon: const Icon(Icons.image_search_rounded),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: OutlinedButton(
              onPressed: () async {
                var bodyJson =
                    jsonEncode(controller.document.toDelta().toJson());
                widget.userArticle.body = bodyJson;
                widget.userArticle.imageUrl = selectedImageUrl;
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
              child: const Text("Done"),
            ),
          ),
        ],
      ),
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
              !showWidget
                  ? Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              showWidget = !showWidget;
                            });
                          },
                          icon: const Icon(Icons.image),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.image_search_rounded),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showWidget = !showWidget;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: showWidget ? 200 : 0,
                  child: Padding(
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
                              imageUrl: selectedImageUrl == ""
                                  ? widget.userArticle.imageUrl!
                                  : selectedImageUrl!,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                      child: Icon(
                                Icons.image_search_outlined,
                                size: 80,
                              )),
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                  ),
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

  @override
  bool get wantKeepAlive => true;
}
