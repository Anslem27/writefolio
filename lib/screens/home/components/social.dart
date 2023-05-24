import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:writefolio/screens/library/components/library_draft_view.dart';
import 'package:writefolio/utils/tools/timeStamp_helper.dart';
import 'package:writefolio/utils/widgets/home/social_wall_post.dart';
import 'package:writefolio/utils/widgets/loader.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class Social extends StatefulWidget {
  const Social({super.key});

  @override
  State<Social> createState() => _SocialState();
}

class _SocialState extends State<Social> {
  // currently logged in user
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textEditingController = TextEditingController();

  /// function to post writing to cloud firstore
  void postWriting() async {
    try {
      if (textEditingController.text.isNotEmpty) {
        //store to firebase
        FirebaseFirestore.instance.collection("User Posts").add({
          "UserEmail": currentUser.email,
          "Writing": textEditingController.text.trim(),
          "TimeStamp": Timestamp.now(),
          "Likes": []
        });
        Navigator.pop(context);
      }
    } catch (e) {
      logger.i(e.toString());
    }
    setState(() {
      textEditingController.clear();
    });
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          context: context,
          isScrollControlled: true,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
        child: const Icon(PhosphorIcons.pencil),
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
                  return ListView.builder(
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
}
