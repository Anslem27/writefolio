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
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                leading: CircleAvatar(
                  child: Text(user.split("@")[0]),
                ),
                subtitle: Text(comment),
                title: Text(
                  "${user.split("@")[0]} • $time",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
