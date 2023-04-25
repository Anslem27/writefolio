// ignore_for_file: file_names

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:writefolio/screens/home/components/recently_read.dart';
import '../../../models/home/guardian_lifestyle.dart';
import '../../../models/home/rself-model.dart';
import '../../../services/explorer_services.dart';
import '../../../utils/widgets/explorer_lifestyle_card.dart';
import '../../../utils/widgets/explorer_rself_card.dart';
import '../../../utils/widgets/loader.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  final hideComponentController = ScrollController();
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    hideComponentController.addListener(() {
      if (hideComponentController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      } else {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var explorerContents = ExplorerContents();
    // final internetStream = InternetConnectionChecker().onStatusChange;
    ScrollController scrollController = ScrollController();

    return FutureBuilder<Rself>(
      future: explorerContents.fetchRselfInfo(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: LoadingAnimation(),
          );
        }
        if (snapshot.hasError) {
          return _noInternet();
        }
        return VsScrollbar(
          controller: scrollController,
          style: const VsScrollbarStyle(
            radius: Radius.circular(5),
            thickness: 3.0,
          ),
          child: ListView(
            controller: scrollController,
            physics: const ScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12),
                child: Row(
                  children: [
                    const Icon(
                      EvaIcons.person,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Self stories".toUpperCase(),
                      textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    const Text("from reddit")
                  ],
                ),
              ),
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: 9,
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) {
                  return ExplorerRselfCard(
                    index: index + 1,
                    rselfObject: snapshot.data!,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "More picks for you.",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12),
                child: Row(
                  children: [
                    const Icon(
                      PhosphorIcons.coat_hanger,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Lifestyle".toUpperCase(),
                      textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<GuardianLifestyle>(
                future: explorerContents.fetchGuardianLifestyle(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: LoadingAnimation());
                  }
                  return ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 9,
                    padding: EdgeInsets.zero,
                    itemBuilder: (_, index) {
                      return LifeStyleCard(
                        index: index,
                        guardianLifestyleObject: snapshot.data!,
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 12),
                child: Row(
                  children: [
                    const Icon(
                      PhosphorIcons.bird,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Culture".toUpperCase(),
                      textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<GuardianLifestyle>(
                future: explorerContents.fetchGuardianCulture(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: LoadingAnimation());
                  }
                  return ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 9,
                    padding: EdgeInsets.zero,
                    itemBuilder: (_, index) {
                      return LifeStyleCard(
                        index: index,
                        guardianLifestyleObject: snapshot.data!,
                      );
                    },
                  );
                },
              ),
            ],
          ),
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
