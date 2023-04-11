import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:writefolio/screens/home/components/explorer_component_view.dart';
import '../../models/home/rself-model.dart';
import '../tools/date_parser.dart';
import '../tools/html_parser.dart';
import '../tools/reading_time_approximator.dart';

class ExplorerRselfCard extends StatelessWidget {
  final int index;
  final Rself rselfObject;
  const ExplorerRselfCard(
      {super.key, required this.index, required this.rselfObject});

  @override
  Widget build(BuildContext context) {
    var listObject = rselfObject.items;
    final filter = ProfanityFilter();
    bool hasProfanity = filter.hasProfanity(rselfObject.items[index].content);
    return InkWell(
      onTap: () {
        var component = listObject[index];
        logger.i(listObject[index].description.trim());
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => ExplorerComponentView(component: component),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "0$index",
                style: GoogleFonts.urbanist(
                    fontSize: 32,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 15,
                        child: Icon(
                          Icons.person,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        listObject[index].author,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      listObject[index].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      htmlToPlainText(listObject[index].description.trim())
                          .toString()
                          .trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: SizedBox(
                            child: Text(
                              "Published: ${dateParser(listObject[index].pubDate)} | ${calculateReadingTime(listObject[index].content)} min read",
                            ),
                          ),
                        ),
                        hasProfanity
                            ? const Text(
                                "nsfw",
                                style: TextStyle(
                                  color: Colors.pink,
                                ),
                              )
                            : const SizedBox(),
                        hasProfanity
                            ? const Icon(
                                Icons.eighteen_up_rating,
                                color: Colors.pink,
                                size: 16,
                              )
                            : const SizedBox()
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
