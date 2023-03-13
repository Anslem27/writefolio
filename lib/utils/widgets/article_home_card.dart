import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:writefolio/utils/widgets/theme_button.dart';
import '../../models/articles/article.dart';
import '../../screens/library/components/article_view.dart';

class ArticleHomeCard extends StatelessWidget {
  final UserArticle userArticle;
  const ArticleHomeCard({super.key, required this.userArticle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                userArticle.title,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4),
              child: Row(
                children: [
                  _userIcon(),
                  const SizedBox(width: 3),
                  const Text("Travis Aaron Wagner"),
                  const Spacer(),
                  Text(
                    userArticle.updateDate,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "4 min read",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: double.maxFinite,
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                userArticle.bodyText,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(),
              ),
            ),
            SButton(
              text: "See details",
              ontap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => ArticleView(userArticle: userArticle),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _userIcon() {
    return const CircleAvatar(
      radius: 17,
      backgroundImage: AssetImage("assets/avatars/Oval-3.png"),
    );
  }
}
