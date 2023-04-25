// ignore_for_file: use_build_context_synchronously

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import '../../animations/fade_in_animation.dart';
import '../../models/poems/saved_poems.dart';
import '../../data/saved_poem_datastore.dart';
import '../../utils/tools/reading_time_approximator.dart';
import 'poems/offline_poemView.dart';

var logger = Logger();

class SavedPoemsScreen extends StatefulWidget {
  const SavedPoemsScreen({super.key});

  @override
  State<SavedPoemsScreen> createState() => _SavedPoemsScreenState();
}

class _SavedPoemsScreenState extends State<SavedPoemsScreen> {
  var poemDatastore = SavedPoemsHiveDataStore();
  var settingsBox = Hive.box("settingsBox");

  @override
  Widget build(BuildContext context) {
    final savedPoemBox = poemDatastore.box;
    return ValueListenableBuilder(
      valueListenable: poemDatastore.listenToSavedPoems(),
      builder: (_, Box<SavedPoems> box, Widget? child) {
        var savedPoems = savedPoemBox.values.toList();

        return Scaffold(
          body: savedPoems.isEmpty
              ? _emptySavedPoems()
              : SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: savedPoems.length,
                        physics: const ScrollPhysics(),
                        itemBuilder: (_, index) {
                          var savedPoem = savedPoems[index];
                          return FloatInAnimation(
                            delay: (1.0 + index) / 5,
                            child: Slidable(
                              key: const ValueKey(0),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) async {
                                      await SavedPoemsHiveDataStore()
                                          .deleteSavedPoem(
                                              savedPoemId: savedPoem.id)
                                          .then((value) {
                                        AnimatedSnackBar.material(
                                          "Deleted: ${savedPoem.title}",
                                          type: AnimatedSnackBarType.info,
                                          duration: const Duration(seconds: 4),
                                          mobileSnackBarPosition:
                                              MobileSnackBarPosition.bottom,
                                        ).show(context);
                                      });

                                      setState(() {});
                                    },
                                    backgroundColor: Colors.pink,
                                    icon: PhosphorIcons.trash,
                                    label: 'Delete',
                                  ),
                                  SlidableAction(
                                    onPressed: (_) {},
                                    backgroundColor: Colors.brown,
                                    icon: Icons.share,
                                    label: 'Share',
                                  ),
                                ],
                              ),
                              child:
                                  savedPoemComponent(context, savedPoem, index),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  savedPoemComponent(BuildContext context, SavedPoems savedPoem, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              await settingsBox.put('recentlyViewedPoem', savedPoem);
              logger.i("Added ${savedPoem.title} to recently read");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OfflinePoemView(
                    poemtitle: savedPoem.title,
                    poemBody: savedPoem.lines,
                    noOfLines: savedPoem.linecount,
                    poet: savedPoem.author,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(3),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                height: MediaQuery.of(context).size.height / 6.5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "0${index + 1}",
                            style: GoogleFonts.urbanist(
                              fontSize: 32,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: int.parse(savedPoem.linecount) > 50
                                  ? Colors.pink
                                  : Colors.blueGrey,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              int.parse(savedPoem.linecount) > 50
                                  ? "long read"
                                  : "short read",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              savedPoem.title.trim().toUpperCase(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                color: Colors.grey,
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 2.0,
                            ),
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
                              vertical: 2.0,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 5.0,
                                ),
                                child: SizedBox(
                                  child: Text(
                                    "${savedPoem.linecount} reading lines | ${calculateReadingTime(savedPoem.lines.toString().replaceAll("\n", "").replaceAll("]", "").replaceAll("[", "")).toString()} min read",
                                  ),
                                ),
                              ),
                              Text(
                                int.parse(savedPoem.linecount) == 14
                                    ? "| sonnet"
                                    : "",
                                style: const TextStyle(
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                    ),

                    /* Container(
                                              width: 80.0,
                                              height: 80.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Image.asset(
                                                  avatars[randomIndex]),
                                            ), */
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Divider(thickness: 0.5),
          )
        ],
      ),
    );
  }

  _emptySavedPoems() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/illustrations/no-fav.svg", height: 200),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "You have no\nsaved content",
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.roboto(fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
