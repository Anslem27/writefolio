import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/home/guardian_lifestyle.dart';
import '../../screens/home/components/explorer_component_view.dart';
import '../tools/date_parser.dart';
import '../tools/reading_time_approximator.dart';

class LifeStyleCard extends StatelessWidget {
  final int index;
  final GuardianLifestyle guardianLifestyleObject;
  const LifeStyleCard(
      {super.key, required this.index, required this.guardianLifestyleObject});

  @override
  Widget build(BuildContext context) {
    var listItem = guardianLifestyleObject.items;
    return InkWell(
      onTap: () {
        var component = listItem[index];
        logger.i(component.description.trim());
        /* Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => ExplorerComponentView(component: component),
          ),
        ); */
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                        listItem[index].author,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.link,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      listItem[index].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: SizedBox(
                          child: Text(
                            " ${dateParser(listItem[index].pubDate)} | ${calculateReadingTime(listItem[index].content)} min read",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    children: List.generate(
                      listItem[index].categories.take(5).length,
                      (categoryIndex) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              listItem[index].categories[categoryIndex],
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
