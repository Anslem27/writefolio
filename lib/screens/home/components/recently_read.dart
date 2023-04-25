import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../models/poems/saved_poems.dart';
import '../poems/offline_poemView.dart';

class RecentlyRead extends StatelessWidget {
  const RecentlyRead({super.key});

  @override
  Widget build(BuildContext context) {
    var settingsbox = Hive.box("settingsBox");
    return ValueListenableBuilder(
      valueListenable: settingsbox.listenable(),
      builder: (_, __, ___) {
        var savedPoemObject = settingsbox.get('recentlyViewedPoem',
            defaultValue: null) as SavedPoems?;

        return savedPoemObject != null
            ? Container(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OfflinePoemView(
                                poemtitle: savedPoemObject.title,
                                poemBody: savedPoemObject.lines,
                                noOfLines: savedPoemObject.linecount,
                                poet: savedPoemObject.author,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 11,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: double.maxFinite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 50),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Continue Reading",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${savedPoemObject.title} by ${savedPoemObject.author}",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: Text("Read"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-0.9, -1.05),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SvgPicture.asset(
                            "assets/illustrations/french.svg",
                            height: 70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox();
      },
    );
  }
}
