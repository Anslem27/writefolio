// ignore_for_file: file_names

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:writefolio/models/saved_poems.dart';
import '../../data/saved_poem_datastore.dart';

var logger = Logger();

class OfflinePoemView extends StatefulWidget {
  final SavedPoems? savedpoem;
  final String poemtitle, noOfLines, poet;
  final List<String> poemBody;
  const OfflinePoemView(
      {super.key,
      required this.poemtitle,
      required this.poemBody,
      required this.noOfLines,
      required this.poet,
      this.savedpoem});

  @override
  State<OfflinePoemView> createState() => _OfflinePoemViewState();
}

class _OfflinePoemViewState extends State<OfflinePoemView> {
  var poemDatastore = SavedPoemsHiveDataStore();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: poemDatastore.listenToSavedPoems(),
        builder: (_, __, ___) {
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
                  onPressed: () {
                    var copied =
                        """${widget.poemtitle}\n${widget.poet}\n${widget.poemBody}"""
                            .replaceAll("[", "")
                            .replaceAll("]", "")
                            .trim();
                    FlutterClipboard.copy(copied).then((value) {
                      logger.i("Copied: $copied");
                      AnimatedSnackBar.material(
                        "Copied to clipboard",
                        type: AnimatedSnackBarType.success,
                        duration: const Duration(seconds: 4),
                        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                      ).show(context);
                    });
                  },
                  icon: const Icon(PhosphorIcons.copy),
                ),
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
        });
  }

  Widget _body(List<String> lines) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
    );
  }
}
