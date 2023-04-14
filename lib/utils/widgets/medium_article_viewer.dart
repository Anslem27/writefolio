// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html2md/html2md.dart' as html2md;
import '../../models/user/medium_user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MediumArticleViewer extends StatelessWidget {
  final Items component;
  const MediumArticleViewer({Key? key, required this.component})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var markdownContent = html2md.convert(component.content);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          var link = component.link;
          launchUrl(Uri.parse(link));
        },
        icon: const Icon(PhosphorIcons.link_simple),
        label: const Text("Open medium"),
      ),
      appBar: AppBar(
        title: Text(
          component.title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              component.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(fontSize: 25, color: Colors.grey),
            ),
          ),
          Markdown(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            selectable: true,
            data: markdownContent,
            styleSheet: MarkdownStyleSheet(
              h1: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
              h2: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
              h3: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
              p: GoogleFonts.roboto(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
                letterSpacing: 0.2,
                height: 1.5,
              ),
              code: const TextStyle(
                fontSize: 14.0,
                backgroundColor: Colors.grey,
              ),
            ),
          ),
          Wrap(
            children: List.generate(
              component.categories.length,
              (categoryIndex) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      component.categories[categoryIndex],
                      style: GoogleFonts.roboto(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
