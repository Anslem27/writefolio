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
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        leading: CircleAvatar(
          radius: 17,
          child: Text(user.split("@")[0][0].toUpperCase()),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${user.split("@")[0]} • ",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16.0,
                ),
              ),
              TextSpan(
                text: time,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(comment),
      ),
    );
  }
}
