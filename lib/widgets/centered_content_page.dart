import 'package:flutter/material.dart';
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
            Image.asset("assets/illustrations/meditating.png"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Profile under\nconstruction...",
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(fontSize: 20),
              ),
            ),
            const BButton(text: "See more")
          ],
        ),
      ),
    );
  }
}
