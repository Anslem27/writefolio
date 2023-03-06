import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class PoemDetailView extends StatefulWidget {
  final String poemtitle, noOfLines, poet;
  final List<String> poemBody;
  const PoemDetailView(
      {super.key,
      required this.poemtitle,
      required this.poemBody,
      required this.noOfLines,
      required this.poet});

  @override
  State<PoemDetailView> createState() => _PoemDetailViewState();
}

class _PoemDetailViewState extends State<PoemDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(PhosphorIcons.share),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.chevron_back,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(PhosphorIcons.download),
          ),
          IconButton(onPressed: () {}, icon: const Icon(PhosphorIcons.copy))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.poemtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text("By ${widget.poet}"),
            _body(widget.poemBody),
          ],
        ),
      )),
    );
  }

  Widget _body(List<String> lines) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Expanded(
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: lines.length,
            itemBuilder: (_, index) {
              return Text(
                lines[index],
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              );
            }),
      ),
    );
  }
}
