// ignore_for_file: file_names

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/utils/widgets/shimmer_component.dart';

import '../../../utils/widgets/explorer_rself_card.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
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
              ],
            ),
          ),
          ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) {
                return ExplorerRselfCard(
                  index: index,
                ); /* ShimmerComponent(
                  deviceWidth: MediaQuery.of(context).size.width,
                  deviceHeight: MediaQuery.of(context).size.height,
                ); */
              })
        ],
      ),
    );
  }
}
