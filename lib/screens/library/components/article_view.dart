import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  var date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
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
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Please Start Writing Better Commits",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: GoogleFonts.urbanist(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  _userIcon(),
                  const SizedBox(width: 3),
                  const Text("Travis Aaron Wagner"),
                  const Spacer(),
                  Text(
                    "${date.month}/${date.day}th/${date.year}",
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "4 min read",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8),
              child: SizedBox(
                width: double.maxFinite,
                child: Divider(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                loremText,
                style: const TextStyle(fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _userIcon() {
    return const CircleAvatar(
      radius: 17,
      backgroundImage: AssetImage("assets/avatars/Oval-3.png"),
    );
  }
}
