// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:writefolio/screens/settings/components/avatar_picker.dart';
import 'package:writefolio/utils/tools/date_parser.dart';
import '../../../models/home/rself-model.dart';
import '../../../utils/tools/html_parser.dart';
import 'package:profanity_filter/profanity_filter.dart';

var logger = Logger();

class ExplorerComponentView extends StatefulWidget {
  final Items component;
  const ExplorerComponentView({
    super.key,
    required this.component,
  });

  @override
  State<ExplorerComponentView> createState() => _ExplorerComponentViewState();
}

class _ExplorerComponentViewState extends State<ExplorerComponentView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var text = htmlToPlainText(widget.component.content)
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll("[comments]", "")
        .trim();

    text = text.substring(0, text.indexOf("submitted by"));

    final filter = ProfanityFilter();

    bool hasProfanity = filter.hasProfanity(text);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(PhosphorIcons.microphone),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.chevron_back,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              PhosphorIcons.share,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AvatarComponent(radius: 17),
                  const SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.component.author.replaceAll("/u/", ""),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.brown,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Text(
                                  "self story",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            hasProfanity
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Text(
                                        "NSFW",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.pink,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Published ${dateParser(widget.component.pubDate)}",
                          style: const TextStyle(),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.component.title,
                textAlign: TextAlign.start,
                style: GoogleFonts.urbanist(
                  fontSize: 25,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            /* Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.maxFinite,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange[900]!.withOpacity(0.5),
                ),
              ),
            ), */
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.maxFinite,
                height: 55,
                child: InkWell(
                  onTap: () {},
                  child: TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            PhosphorIcons.reddit_logo,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Continue in reddit",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
