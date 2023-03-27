import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../../utils/constants.dart';
import '../../../data/saved_poem_datastore.dart';
import '../../../services/poem_service.dart';
import '../../../utils/widgets/reading_time_approximator.dart';
import '../poems/poem_detail_view.dart';

var logger = Logger();

class PoemQuerySearch extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search by author';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(CupertinoIcons.chevron_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
              children: [
                SvgPicture.asset("assets/svg/joy.svg", height: 200),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Search query must be longer than two letters.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }

    var poemDatastore = SavedPoemsHiveDataStore();

    return ValueListenableBuilder(
        valueListenable: poemDatastore.listenToSavedPoems(),
        builder: (_, __, ___) {
          return FutureBuilder(
            future: PoemService.fetchSearch(query.trim()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (snapshot.data!.poem!.isEmpty || snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/svg/article.svg",
                        height: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "No results\nfor ${query.trim()}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 0.5,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text("Go home"),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                logger.i(snapshot.data!.poem); //log returned query
                return ListView.builder(
                  itemCount: snapshot.data!.poem!.length,
                  itemBuilder: (_, index) {
                    int randomIndex = Random().nextInt(avatars.length);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => PoemDetailView(
                                    poemtitle:
                                        snapshot.data!.poem![index].title,
                                    poemBody: snapshot.data!.poem![index].lines,
                                    noOfLines:
                                        snapshot.data!.poem![index].linecount,
                                    poet: snapshot.data!.poem![index].author,
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
                                            snapshot.data!.poem![index].title
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
                                            "By ${snapshot.data!.poem![index].author}",
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
                                                  "${snapshot.data!.poem![index].linecount} reading lines |  ${calculateReadingTime(snapshot.data!.poem![index].lines.toString().replaceAll("\n", "").replaceAll("]", "").replaceAll("[", "")).toString()} min read",
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
                                    child: Image.asset(avatars[randomIndex]),
                                  ),
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
                    );
                  },
                );
              }
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Column(
            children: [
              SvgPicture.asset("assets/svg/idea.svg", height: 200),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Type Author's name.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400, fontSize: 20),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
