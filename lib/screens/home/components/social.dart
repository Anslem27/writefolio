// import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/screens/library/components/library_draft_view.dart';
import 'package:writefolio/utils/tools/timeStamp_helper.dart';
import 'package:writefolio/utils/widgets/home/social_wall_post.dart';
import 'package:writefolio/utils/widgets/loader.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class Social extends StatefulWidget {
  const Social({super.key});

  @override
  State<Social> createState() => _SocialState();
}

class _SocialState extends State<Social> {
  // currently logged in user
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textEditingController = TextEditingController();
  final titleController = TextEditingController();

  // Define a ScrollController
  final ScrollController _scrollController = ScrollController();
  bool isScrollEnd = false;

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      floatingActionButton: Visibility(
        visible: showFab,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WritingEditor()),
            );
          },
          child: const Icon(FluentIcons.pen_24_regular),
        ),
      ),
      body: Column(
        children: [
          // social wall posts
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy("TimeStamp", descending: false)
                  .snapshots(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: LoadingAnimation(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error ${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification &&
                          _scrollController.position.extentAfter == 0) {
                        // User has reached the end of the list, show the notification
                        HapticFeedback.vibrate();
                        setState(() {
                          isScrollEnd = true;
                        });
                      }
                      return false;
                    },
                    child: ListView(
                      controller: _scrollController,
                      physics: const ScrollPhysics(),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (_, index) {
                            final post = snapshot.data!.docs[index];
                            return SocialWallPost(
                              message: post["Writing"],
                              user: post["UserEmail"],
                              postId: post.id,
                              likes: List<String>.from(post["Likes"] ?? []),
                              time: formatTimeStamp(post["TimeStamp"]),
                            );
                          },
                        ),

                        /// indicator for end of posts
                        isScrollEnd == true
                            ? AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      transitionBuilder: (child, animation) {
                                        return RotationTransition(
                                          turns: animation,
                                          child: child,
                                        );
                                      },
                                      child: Icon(
                                        //should listen to the isScrollEnd event
                                        // i want a fluid drag scroll up animation with a chevron up like
                                        // icon as the user scrolls up and then turns to the check circle once the animation is done
                                        Icons.keyboard_arrow_up,
                                        size: 35,
                                        color: Colors.green[700],
                                        key: UniqueKey(),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            child: Text(
                                              "Thats all for now!",
                                              style: GoogleFonts.roboto(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  /*  Future<dynamic> writeContentsSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'What do you want to share?',
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: "Share writing",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: postWriting,
                          icon: const Icon(FluentIcons.send_24_filled),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } */
}

class WritingEditor extends StatefulWidget {
  const WritingEditor({Key? key});

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
              style: GoogleFonts.urbanist(),
              decoration: const InputDecoration(
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
                      left: 8.0,
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
                    decoration: const InputDecoration(
                      hintText: "Add tags",
                    ),
                  ),
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
