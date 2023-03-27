// ignore_for_file: file_names

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../../data/saved_poem_datastore.dart';
import '../../../models/rself-model.dart';
import '../../../utils/tools/html_parser.dart';

var logger = Logger();

class ExplorerComponentView extends StatefulWidget {
  final Items component;
  const ExplorerComponentView({
    super.key,
    required this.component,
  });

  @override
  State<ExplorerComponentView> createState() => _ExplorerComponentViewState();
}

class _ExplorerComponentViewState extends State<ExplorerComponentView> {
  var poemDatastore = SavedPoemsHiveDataStore();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var text = htmlToPlainText(widget.component.content)
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll("[comments]", "")
        .trim();

    text = text.substring(0, text.indexOf("submitted by"));
    return ValueListenableBuilder(
        valueListenable: poemDatastore.listenToSavedPoems(),
        builder: (_, __, ___) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(PhosphorIcons.microphone),
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
                    var copied = text;
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    PhosphorIcons.share,
                  ),
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
                      widget.component.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "By   ${widget.component.author}",
                    style: TextStyle(color: Colors.orange[900]),
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )),
          );
        });
  }
}
