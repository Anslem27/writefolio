import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BButton extends StatelessWidget {
  final String text;
  final Function()? ontap;
  final double? width;
  const BButton({super.key, required this.text, this.ontap, this.width});

  @override
  Widget build(BuildContext context) {
    bool darkModeOn =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    double deviceWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: width ?? deviceWidth / 1.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: darkModeOn ? Colors.white : const Color(0xff181717),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: darkModeOn ? const Color(0xff181717) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class SButton extends StatelessWidget {
  final String text;
  final Function()? ontap;
  final double? width;
  const SButton({super.key, required this.text, this.ontap, this.width});

  @override
  Widget build(BuildContext context) {
    bool darkModeOn =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    double deviceWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 45,
          width: width ?? deviceWidth / 0.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: darkModeOn ? Colors.white : const Color(0xff181717),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: darkModeOn ? const Color(0xff181717) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
