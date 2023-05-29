import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiavatar/multiavatar.dart';
import 'package:writefolio/screens/settings/components/avatar_picker.dart';
import 'package:writefolio/utils/widgets/home/social_wall_item_likebutton.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../tools/timeStamp_helper.dart';
import '../animated_icon.dart';
import '../loader.dart';
import 'increment_animated_text.dart';
import 'social_wall_comment.dart';

class SocialWallPost extends StatefulWidget {
  final String message, user, time;
  final String postId;
  final List<String> likes;
  const SocialWallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  });

  @override
  State<SocialWallPost> createState() => _SocialWallPostState();
}

class _SocialWallPostState extends State<SocialWallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final commentEditingController = TextEditingController();

  bool isLiked = false;

  @override
  void initState() {
    isLiked = widget.likes.contains(currentUser.email);
    super.initState();
  }

  // toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // access document in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if (isLiked) {
      // add to liked users list
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      // remove from liked users list
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  // add a comment
  void addComment(String comment) {
    // write comment to firestore with [Comment collection]
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": comment,
      "CommentedBy": currentUser.email,
      "CommentedAt": Timestamp.now(),
    });
    Navigator.pop(context); // close dialog
    //show success to comment
    AnimatedSnackBar.material(
      "👍 Comment shared",
      type: AnimatedSnackBarType.success,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    ).show(context);
  }

  // add comment sheet
  void showCommentSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Share your thought?',
                      style: GoogleFonts.ubuntu(
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
                            controller: commentEditingController,
                            decoration: InputDecoration(
                              labelText: "Share comment",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedIconButton(
                            onPressed: () {
                              addComment(commentEditingController.text.trim());
                              commentEditingController.clear();
                            },
                            icon: const Icon(FluentIcons.send_24_filled),
                          ),
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
  }

  // comment bottom sheet
  void showComments() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentedAt", descending: true)
                .snapshots(),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const LoadingAnimation();
              }
              final comments = snapshot.data!.docs;
              final commentCount = comments.length;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Comments ($commentCount)',
                            style: GoogleFonts.ubuntu(
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onTap: () {
                        showCommentSheet();
                      },
                      leading: const AvatarComponent(radius: 14),
                      title: const Text("Share your thought..."),
                    ),
                    const Divider(),
                    ListView(
                      shrinkWrap: true,
                      children: comments.map((doc) {
                        final commentData = doc.data() as Map<String, dynamic>;

                        return SocialWallComment(
                          comment: commentData["CommentText"],
                          user: commentData["CommentedBy"],
                          time: formatTimeStamp(commentData["CommentedAt"]),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var multiAvatarSvg = multiavatar(widget.user.toString());
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // title
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    'Post Heading',
                    style: GoogleFonts.urbanist(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onSelected: (value) {
                        // Do something when an item is selected
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'share',
                          child: Row(
                            children: [
                              Icon(FluentIcons.share_24_filled, size: 20),
                              SizedBox(width: 2),
                              SizedBox(width: 3),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Share'),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'save',
                          child: Row(
                            children: [
                              Icon(PhosphorIcons.bookmark, size: 20),
                              SizedBox(width: 2),
                              SizedBox(width: 3),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(PhosphorIcons.trash, size: 20),
                              SizedBox(width: 2),
                              SizedBox(width: 3),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: SizedBox(
                        // padding: const EdgeInsets.all(5),
                        /*  decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ), */
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            widget.message,
                            maxLines: 5,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Material(
                      type: MaterialType.transparency,
                      child: Text(
                        'Read More',
                        style: TextStyle(
                          color: Colors.blue, // Set the desired color here
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: SvgPicture.string(multiAvatarSvg,
                                    height: 27, width: 27),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.user.split("@")[0]),
                              ),
                              Text(
                                "• ${widget.time}",
                                style: GoogleFonts.roboto(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          // const Spacer(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //TODO: https://pub.dev/packages/like_button
                          WallComponentLikeButton(
                            isLiked: isLiked,
                            ontap: toggleLike,
                          ),
                          const SizedBox(width: 6),
                          IncrementAnimatedText(
                            value: widget.likes.length,
                            textStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showComments();
                            },
                            icon: const Icon(FluentIcons.comment_24_regular),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("User Posts")
                                .doc(widget.postId)
                                .collection("Comments")
                                .orderBy("CommentedAt", descending: true)
                                .snapshots(),
                            builder: (_, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                "${snapshot.data!.docs.length}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                          /* const SizedBox(width: 10),
                          AnimatedIconButton(
                            onPressed: () {
                              showCommentSheet();
                            },
                            icon: const Icon(FluentIcons.comment_add_20_regular),
                          ), */
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
