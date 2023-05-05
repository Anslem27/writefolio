// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/screens/settings/components/avatar_picker.dart';
import 'package:writefolio/utils/tools/date_parser.dart';
import '../../../models/home/guardian_lifestyle.dart';
import '../../../utils/tools/html_parser.dart';
import 'package:profanity_filter/profanity_filter.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class GuardianComponentView extends StatefulWidget {
  final GuardianLifestyle component;
  const GuardianComponentView({
    super.key,
    required this.component,
  });

  @override
  State<GuardianComponentView> createState() =>
      _GuardianComponentViewViewState();
}

class _GuardianComponentViewViewState extends State<GuardianComponentView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ProfanityFilter();

    return Scaffold(
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
        body: SafeArea(child: Builder(builder: (_) {
          for (var component in widget.component.items) {
            var text = component.content;
            text = htmlToPlainText(text).toString();
            bool hasProfanity = filter.hasProfanity(text);
            return SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    component.author.replaceAll("/u/", ""),
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Card(
                                    child: Container(
                                      decoration: const BoxDecoration(),
                                      child: const Padding(
                                        padding: EdgeInsets.all(3.0),
                                        child: Text(
                                          "self story",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  hasProfanity
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                "Published ${dateParser(component.pubDate)}",
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
                      component.title,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.urbanist(
                        fontSize: 25,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text.replaceAll("Continue reading", ""),
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
                            onPressed: () async {
                              if (!await launchUrl(
                                  Uri.parse(component.link))) {
                                throw Exception(
                                    'Could not launch ${component.link}');
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  PhosphorIcons.link,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Continue reading",
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
            );
          }
          return const SizedBox();
        })));
  }
}
