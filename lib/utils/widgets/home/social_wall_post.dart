import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/utils/widgets/home/social_wall_item_likebutton.dart';
import '../../../screens/settings/components/avatar_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class SocialWallPost extends StatefulWidget {
  final String message, user;
  final String postId;
  final List<String> likes;
  const SocialWallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  });

  @override
  State<SocialWallPost> createState() => _SocialWallPostState();
}

class _SocialWallPostState extends State<SocialWallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
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
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(FluentIcons.share_24_filled),
                        ),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            children: [
                              Text(
                                'Comments',
                                style: GoogleFonts.ubuntu(fontSize: 16),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                '10',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              /* const AvatarComponent(radius: 17),
                              const SizedBox(width: 10), */
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle the onTap event to display the modal dialog
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Text("Add a comment..."),
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
            ],
          ),
          //const Divider(),
        ],
      ),
    );
  }
}
