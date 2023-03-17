import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  child: const Text("See more"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
