import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../../../utils/tools/reading_time_approximator.dart';
import 'avatar_picker.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: const ScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AvatarComponent(radius: 20),
                const SizedBox(width: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Writefolio Team",
                            style: GoogleFonts.roboto(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: SizedBox(
                            child: Text(
                              "${calculateReadingTime(tOS)} min read",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Writefolio Terms of Service",
              style: GoogleFonts.roboto(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tOS,
              style: GoogleFonts.roboto(),
            ),
          )
        ],
      ),
    );
  }
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: const ScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AvatarComponent(radius: 20),
                const SizedBox(width: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Writefolio Team",
                            style: GoogleFonts.roboto(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: SizedBox(
                            child: Text(
                              "${calculateReadingTime(privacyPolicy)} min read",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Writefolio's Privacy Policy",
              style: GoogleFonts.roboto(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              privacyPolicy,
              style: GoogleFonts.roboto(),
            ),
          )
        ],
      ),
    );
  }
}
