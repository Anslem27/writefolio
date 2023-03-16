// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/utils/widgets/shimmer_component.dart';

class RSelf extends StatefulWidget {
  const RSelf({super.key});

  @override
  State<RSelf> createState() => _RSelfState();
}

class _RSelfState extends State<RSelf> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Find Inspiration from people expressing them-selves.",
              style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w500,
                fontSize: 25,
              ),
            ),
          ),
          ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (_, index) {
                return ShimmerComponent(
                  deviceWidth: MediaQuery.of(context).size.width,
                  deviceHeight: MediaQuery.of(context).size.height,
                );
              })
        ],
      ),
    );
  }
}
