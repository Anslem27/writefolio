import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/theme_button.dart';

class CenteredPage extends StatefulWidget {
  const CenteredPage({super.key});

  @override
  State<CenteredPage> createState() => _CenteredPageState();
}

class _CenteredPageState extends State<CenteredPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/svg/read.svg"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "I'ts not you\ni'ts us",
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(fontSize: 20),
              ),
            ),
            const BButton(text: "See more")
          ],
        ),
      ),
    );
  }
}
