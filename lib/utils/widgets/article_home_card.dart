import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/articles/article.dart';
import '../../screens/library/components/article_view.dart';
import '../../screens/settings/components/avatar_picker.dart';
import 'reading_time_approximator.dart';

class ArticleHomeCard extends StatelessWidget {
  final UserArticle userArticle;
  const ArticleHomeCard({super.key, required this.userArticle});
  //TODO: Add image service and also tags

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        userArticle.title,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    //  const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                  child: Row(
                    children: [
                      const Text(
                        "Last Editted:",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        userArticle.updateDate,
                      ),
                      const SizedBox(width: 8),
                      const Text("•"),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(PhosphorIcons.clock),
                          Text(
                            "${calculateReadingTime(userArticle.bodyText).toString()} min read",
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const AvatarComponent(radius: 17),
                    ],
                  ),
                ),
                const SizedBox(
                  width: double.maxFinite,
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          userArticle.bodyText.replaceAll("\n", " "),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: 90,
                          height: 100,
                          child: CachedNetworkImage(
                            imageUrl: userArticle.imageUrl,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Center(
                                child: Icon(
                              Icons.image_search_outlined,
                              size: 80,
                            )),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) =>
                                    ArticleView(userArticle: userArticle),
                              ),
                            );
                          },
                          child: Text(
                            "See details",
                            style: GoogleFonts.urbanist(fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
