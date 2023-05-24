import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/utils/widgets/home/social_wall_item_likebutton.dart';
import '../../../screens/settings/components/avatar_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../tools/timeStamp_helper.dart';
import '../loader.dart';
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
      "👍",
      type: AnimatedSnackBarType.success,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    ).show(context);
  }

  // add comment sheet
  void showCommentSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  IconButton(
                    onPressed: () {
                      addComment(commentEditingController.text.trim());
                      commentEditingController.clear();
                    },
                    icon: const Icon(FluentIcons.send_24_filled),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // comment bottom sheet
  void showComments() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Comments',
                style: GoogleFonts.ubuntu(
                  fontSize: 19,
                ),
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .orderBy("CommentedAt", descending: true)
                  .snapshots(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: LoadingAnimation(),
                  );
                }
                return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((doc) {
                      // get comment from firstore
                      final commentData = doc.data() as Map<String, dynamic>;

                      return SocialWallComment(
                        comment: commentData["CommentText"],
                        user: commentData["CommentedBy"],
                        time: formatTimeStamp(commentData["CommentedAt"]),
                      );
                    }).toList());
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: AvatarComponent(radius: 17),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.user.split("@")[0]),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        //TODO: https://pub.dev/packages/like_button
                        WallComponentLikeButton(
                          isLiked: isLiked,
                          ontap: toggleLike,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${widget.likes.length}",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(width: 3),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(FluentIcons.share_24_filled),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Post Heading',
                      style: GoogleFonts.ubuntu(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style:
                          GoogleFonts.roboto(fontSize: 14, color: Colors.grey),
                    ),
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
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        /* const AvatarComponent(radius: 17),
                              const SizedBox(width: 10), */
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showCommentSheet();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text("Share your thought..."),
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(FluentIcons.comment_24_regular),
                        ),
                        const Text(
                          "2",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          //const Divider(),
        ],
      ),
    );
  }
}
