// ignore_for_file: file_names

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:writefolio/utils/widgets/shimmer_component.dart';
import '../../../models/guardian_lifestyle.dart';
import '../../../models/rself-model.dart';
import '../../../services/explorer_services.dart';
import '../../../utils/widgets/explorer_lifestyle_card.dart';
import '../../../utils/widgets/explorer_rself_card.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  @override
  Widget build(BuildContext context) {
    var explorerContents = ExplorerContents();

    ScrollController scrollController = ScrollController();

    return StreamBuilder<InternetConnectionStatus>(
      stream: InternetConnectionChecker().onStatusChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final status = snapshot.data;
          if (status == InternetConnectionStatus.connected) {
            return FutureBuilder<Rself>(
              future: explorerContents.fetchRselfInfo(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const Text("Sorted by newest")
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
                          style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
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
                              "Lifestyle stories".toUpperCase(),
                              textAlign: TextAlign.start,
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<GuardianLifestyle>(
                          future: explorerContents.fetchGuardianLifestyle(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
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
                          }),
                    ],
                  ),
                );
              },
            );
          } else {
            return _noInternet();
          }
        } else {
          return ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            padding: EdgeInsets.zero,
            itemBuilder: (_, index) {
              return ShimmerComponent(
                deviceWidth: MediaQuery.of(context).size.width,
                deviceHeight: MediaQuery.of(context).size.height,
              );
            },
          );
        }
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
