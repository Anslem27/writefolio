import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import "dart:math";
import '../../animations/fade_in_animation.dart';
import '../../utils/constants.dart';
import '../../models/poems/poem_models.dart';
import '../../services/poem_service.dart';
import '../../utils/widgets/reading_time_approximator.dart';
import 'poems/poem_detail_view.dart';

var logger = Logger();

class PoemView extends StatefulWidget {
  const PoemView({super.key});

  @override
  State<PoemView> createState() => _PoemViewState();
}

class _PoemViewState extends State<PoemView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomePoemList>(
      future: PoemService.fetchHome(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return _noInternet();
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.poem!.length,
          itemBuilder: (_, index) {
            int randomIndex = Random().nextInt(avatars.length);
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
                            builder: (_) => PoemDetailView(
                              poemtitle: snapshot.data!.poem![index].title,
                              poemBody: snapshot.data!.poem![index].lines,
                              noOfLines: snapshot.data!.poem![index].linecount,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "By ${snapshot.data!.poem![index].author}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: SizedBox(
                                          child: Text(
                                            "${snapshot.data!.poem![index].linecount} reading lines . ${calculateReadingTime(snapshot.data!.poem![index].lines.toString().replaceAll("\n", "").replaceAll("]", "").replaceAll("[", "")).toString()} min read",
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
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
              ),
            );
          },
        );
      },
    );
  }

  _noInternet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/illustrations/no-connection.svg",
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "No Internet\nconnection",
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w400, fontSize: 19),
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            child: Text(
              "Open settings",
              style: GoogleFonts.urbanist(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}
