import 'package:flutter/material.dart';

class SocialWallComment extends StatelessWidget {
  final String comment, user, time;
  const SocialWallComment(
      {super.key,
      required this.comment,
      required this.user,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          // comment
          Text(comment),
          //user,time
          Text("$user $time")
        ],
      ),
    );
  }
}
