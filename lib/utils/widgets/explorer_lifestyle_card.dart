import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/guardian_lifestyle.dart';
import '../tools/date_parser.dart';
import 'reading_time_approximator.dart';

class LifeStyleCard extends StatelessWidget {
  final int index;
  final GuardianLifestyle guardianLifestyleObject;
  const LifeStyleCard(
      {super.key, required this.index, required this.guardianLifestyleObject});

  @override
  Widget build(BuildContext context) {
    var listItem = guardianLifestyleObject.items;
    return Padding(
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
                      icon: const Icon(Icons.link),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(PhosphorIcons.share),
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
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
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
    );
  }
}
