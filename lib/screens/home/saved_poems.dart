import 'dart:math';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import '../../animations/fade_in_animation.dart';
import '../../models/poems/saved_poems.dart';
import '../../utils/constants.dart';
import '../../data/saved_poem_datastore.dart';
import 'poems/offline_poemView.dart';

var logger = Logger();

class SavedPoemsScreen extends StatefulWidget {
  const SavedPoemsScreen({super.key});

  @override
  State<SavedPoemsScreen> createState() => _SavedPoemsScreenState();
}

class _SavedPoemsScreenState extends State<SavedPoemsScreen> {
  var poemDatastore = SavedPoemsHiveDataStore();
  @override
  Widget build(BuildContext context) {
    bool darkModeOn =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final savedPoemBox = poemDatastore.box;
    return ValueListenableBuilder(
      valueListenable: poemDatastore.listenToSavedPoems(),
      builder: (_, Box<SavedPoems> box, Widget? child) {
        var savedPoems = savedPoemBox.values.toList();

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(
              PhosphorIcons.magnifying_glass,
            ),
          ),
          body: savedPoems.isEmpty
              ? _emptySavedPoems(darkModeOn)
              : ListView.builder(
                  itemCount: savedPoems.length,
                  itemBuilder: (_, index) {
                    var savedPoem = savedPoems[index];
                    logger.i(savedPoem); //log returned query
                    int randomIndex = Random().nextInt(poemAvatars.length);
                    return FloatInAnimation(
                      delay: (1.0 + index) / 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => OfflinePoemView(
                                      poemtitle: savedPoem.title,
                                      poemBody: savedPoem.lines,
                                      noOfLines: savedPoem.linecount,
                                      poet: savedPoem.author,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                height: MediaQuery.of(context).size.height / 7,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              savedPoem.title
                                                  .trim()
                                                  .toUpperCase(),
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.urbanist(
                                                  fontSize: 16.5,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              "By ${savedPoem.author}",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5.0),
                                                child: SizedBox(
                                                  child: Text(
                                                    "${savedPoem.linecount} reading lines",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                    ),
                                    Container(
                                      width: 80.0,
                                      height: 80.0,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child:
                                          Image.asset(poemAvatars[randomIndex]),
                                    ),
                                    //delete button
                                    IconButton(
                                      onPressed: () {
                                        SavedPoemsHiveDataStore()
                                            .deleteSavedPoem(
                                                savedPoem: savedPoem)
                                            .then((value) {
                                          AnimatedSnackBar.material(
                                            "Deleted: ${savedPoem.title}",
                                            type: AnimatedSnackBarType.info,
                                            duration:
                                                const Duration(seconds: 4),
                                            mobileSnackBarPosition:
                                                MobileSnackBarPosition.bottom,
                                          ).show(context);
                                        });
                                      },
                                      icon: const Icon(PhosphorIcons.trash),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Divider(thickness: 0.5),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  _emptySavedPoems(bool darkModeOn) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //TODO: Add darkmode illustration
          SvgPicture.asset(
            "assets/svg/reading-side.svg",
            color: !darkModeOn ? Colors.black : Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "No saved\npoems",
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
