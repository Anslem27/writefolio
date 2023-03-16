import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class ExplorerRselfCard extends StatelessWidget {
  final int index;
  const ExplorerRselfCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "0${index + 1}",
              style: GoogleFonts.urbanist(
                fontSize: 35,
                color: Colors.grey,
              ),
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
                        PhosphorIcons.magic_wand,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "u/urbanDistartor",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Ukraine war,15th March 2023:Standstill",
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
                    const Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: SizedBox(
                        child: Text(
                          "1 day ago | 8 min read",
                        ),
                      ),
                    ),
                    index.isEven
                        ? const Icon(
                            Icons.star,
                            color: Colors.deepOrange,
                            size: 16,
                          )
                        : const SizedBox()
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
