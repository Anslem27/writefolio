import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:writefolio/models/poems/poem_models.dart';
import '../../../services/poem_service.dart';
import '../../../utils/tools/reading_time_approximator.dart';
import '../../../utils/widgets/loader.dart';
import '../poems/poem_detail_view.dart';

//flutter search delegate page with 3 taps each with a body for different futures building a different resuly
//taps should be postioned to mainaxisalignment.start

var logger = Logger();

class PoemQuerySearch extends SearchDelegate {
  @override
  String get searchFieldLabel => 'search by author or theme';

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
    return FutureBuilder(
      future: PoemService.fetchSearch(query.trim()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(child: LoadingAnimation()),
            ],
          );
        } else if (snapshot.data!.poem!.isEmpty || snapshot.hasError) {
          return emptyPoemSearchResults(context);
        } else {
          logger.i(snapshot.data!.poem); //log returned query
          return ListView.builder(
            itemCount: snapshot.data!.poem!.length,
            itemBuilder: (_, index) {
              return homePoemQueryComponent(context, snapshot, index, false);
            },
          );
        }
      },
    );
  }

  homePoemQueryComponent(BuildContext context,
      AsyncSnapshot<HomePoemList> snapshot, int index, bool isSonnet) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PoemDetailView(
                    poemtitle: snapshot.data!.poem![index].title,
                    poemBody: snapshot.data!.poem![index].lines,
                    noOfLines: snapshot.data!.poem![index].linecount,
                    poet: snapshot.data!.poem![index].author,
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
                height: MediaQuery.of(context).size.height / 7,
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
                              color: int.parse(snapshot
                                          .data!.poem![index].linecount) >
                                      50
                                  ? Colors.pink
                                  : Colors.blueGrey,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              int.parse(snapshot.data!.poem![index].linecount) >
                                      50
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
                              snapshot.data!.poem![index].title
                                  .trim()
                                  .toUpperCase(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: 16.5,
                                color: Colors.grey,
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
                              "By ${snapshot.data!.poem![index].author}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: SizedBox(
                                  child: Text(
                                    "${snapshot.data!.poem![index].linecount} reading lines . ${calculateReadingTime(snapshot.data!.poem![index].lines.toString().replaceAll("\n", "").replaceAll("]", "").replaceAll("[", "")).toString()} min read",
                                  ),
                                ),
                              ),
                              Text(
                                int.parse(snapshot
                                            .data!.poem![index].linecount) ==
                                        14
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

  Center emptyPoemSearchResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/illustrations/none-found.svg",
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
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FutureBuilder<PoetList>(
          future: PoemService.fetchPoetSuggestions(),
          builder: (_, suggestionsSnapshot) {
            if (suggestionsSnapshot.hasError) {
              return const SizedBox();
            }
            if (!suggestionsSnapshot.hasData) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: LoadingAnimation(),
              ));
            }
            return ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  child: Text(
                    "suggestions",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Wrap(
                  children: List.generate(
                      suggestionsSnapshot.data!.poets!.length,
                      (index) => InkWell(
                            onTap: () {
                              query = suggestionsSnapshot
                                  .data!.poets![index].author
                                  .toString();
                              //buildResults(context);
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(suggestionsSnapshot
                                    .data!.poets![index].author
                                    .toString()),
                              ),
                            ),
                          )),
                ),
              ],
            );
          },
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                SvgPicture.asset("assets/illustrations/no-notification.svg",
                    height: 200),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: Text(
                    "search by poet or theme",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
